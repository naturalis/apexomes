# The `apexomes` project

![Auzoux paper mache gorilla](http://www.museumboerhaave.nl/media/uploads/medialibrary/2015/09/Gorilla_van_Auzoux_groot.jpg "Auzoux paper mache gorilla")

The apexomes project is a [Generade](https://generade.nl/) collaboration between [LUMC](https://www.lumc.nl/), 
[Hogeschool Leiden](https://www.hsleiden.nl), [Museum Boerhaave](http://www.museumboerhaave.nl/) and 
[Naturalis Biodiversity Center](http://www.naturalis.nl). In this project a pipeline is built to identify the 
subspecies of a gorilla museum specimen by comparing the specimen's genetic variation with other, previously 
identified gorilla individuals from different subspecies. The genetic variation data are generated by performing 
a mapping assembly against a reference genome. Subsequently, variant calling is performed to derive SNPs that 
are compared with SNPs we have obtained from previously published studies. This repository contains the scripts 
and config files for this pipeline. The pipeline has only been tested with gorilla data, but shouldn’t be 
organism-specific, provided the right reference genome is used. The pipeline has been running in a cloud instance 
on Naturalis's [OpenStack](https://stack.naturalis.nl) environment. 

## About the pipeline
The pipeline consists of an [interactive wrapper](script/startPipeline.sh) around a 
[driver script](script/apexomesPipeline.sh) that takes the following steps:

1. Optionally, [reads are trimmed](script/trimmer.sh) using `sickle`
2. [Reads are mapped](script/bwa.sh) (paired end) against the reference using `bwa`
3. [Mapping is filtered, sorted and indexed](script/bwa.sh) using `samtools`
4. [Variants are called](script/variantcalling.sh) using `freebayes`

The pipeline works with paired end reads. It needs exactly two files, one forward and one reverse. It also uses a 
(downloaded) reference genome. The settings for the pipeline are stored in a [configuration file](conf/config.txt). 
This configuration file stores the location of the reference genome, the location of the reads and the desired 
output directories. This file should be edited before running the pipeline.

Once the pipeline is finished you will have a VCF file to use for further downstream analysis, i.e. clustering
of the specimen with other reference specimens. Clustering can be done with many combinations with datasets. To begin 
with clustering you must determine what exactly you want to cluster. For example: Do you want to use a reference? 
Do you want to have a coding reference or raw reference? 

#### Reduce reference to coding only
If you want to have a dataset only for coding genes (i.e. exomic loci), use the 
[Extract-cdna-headers.bash](script/Extract-cdna-headers.bash) script. Please change the input directory variable 
"inputvcfdir" and change the output directory variable "outputdir" to the right directories.

#### Merge reference with your data
This step is repetitive. First you have to compress the two vcf files you want to merge, for example `reference.vcf` 
and `Auzoux.vcf`. In order to do this, first you have to run:
``` bash
# compress the reference
bgzip reference.vcf
# index the reference
tabix -p vcf reference.vcf.gz
# compress the individual
bgzip Auzoux.vcf
# index the individual
tabix -p vcf Auzoux.vcf.gz
```
This is to compress the files and create indexes so they can be used for merging. The merging can be done by
`bcftools merge reference.vcf.gz Auzoux.vcf.gz > AuzouxMergedWithRef.vcf`
This will create a large file for the Auzoux Gorilla and the reference. If you want to add more gorillas, then you have
to run de bgzip for the new large reference file and your next Gorilla.

#### Clustering
To do the clustering itself you have to convert the vcf file to the plink format file. This can be done by:
``` bash
vcftools --vcf INPUTFILE.vcf --plink --out  OUTPUTFILE.raw
```

Now you have to run two plink commands:
``` bash
plink --file OUTPUTFILE.raw --genome --noweb --allow-no-sex --out OUTPUTFILE.raw
plink --file OUTPUTFILE.raw --read-genome OUTPUTFILE.raw.genome --cluster --mds-plot 2 --noweb
```

After that you can load the result file into R and visualize it.
Example code:
``` r
getwd()
d <- read.table("plink.mds", h=T)
print("Auzoux can have different locations")
d$pop = factor(c(rep("GBB", 7), rep("GBG", 9), rep("GGD", 1), rep("GGG", 27), rep("Sandra"), "Thirza", "Auzoux"))
d$pop
refnames <- c( "GBB - Eastern Gorilla", "GBG - Eastern Gorilla", "GGD - Western Gorilla", "GGG - Western Gorilla")
plot(d$C1, d$C2, col=as.integer(d$pop), pch=19, xlab="Dimension 1", ylab="Dimension 2", main = "MDS analysis on chromosome 1 reference, Sandra, Thirza and Auzoux ")
legend("topleft", c("Auzoux", refnames, "Sandra", "Thirza"), pch=19, col=c(1,2,3,4, 5, 6, 7))
text(d$C1, d$C2, labels=c(rep(NA, 22), "Sandra", "Naam hier"), pos=2)
text(d$C1, d$C2, labels=c(rep(NA, 44), "Sandra", NA), pos=2)
text(d$C1, d$C2, labels=c(rep(NA, 45), "Thirza", NA), pos=1)
text(d$C1, d$C2, labels=c(rep(NA, 46), "Auzoux", NA), pos=1)`
```

#### Dependencies
The work environment has been created on an Ubuntu operating system. Below are the used applications and dependencies, including 
the used version and the commandline installation command. 
 - Git (1.9.1): sudo apt-get install git
 - Sickle (1.33): git clone https://github.com/najoshi/sickle
 - Make (3.81): sudo apt-get install make
 - Gcc (4.8.4): sudo apt-get install gcc
 - Zlib1g-dev (1.26): sudo apt-get install zlib1g-dev
 - python-pip (2.7.6): sudo apt-get install python-pip
 - python-dev (2.7.6): sudo apt-get install python-dev
 - ftp-cloudfs (0.34): sudo pip install ftp-cloudfs python-keystoneclient python-swiftclient 
 - BWA (0.7.5a-r405): sudo apt-get install bwa
 - SAMtools (0.1.19-96b5f2294a): git clone git://github.com/samtools/samtools.git   
    sudo apt-get install samtools
 - Freebayes (1.0.2): https://github.com/ekg/freebayes
 - Freebayes compiler: Sudo apt-get install cmake

To (re)install these dependencies on a fresh instance of Ubuntu 14.04LTS, a 
[puppet manifest](https://github.com/naturalis/puppet-apexomes) is under development.

## About the data

The cloud instance on which the pipeline is run mounts a separate data volume as `/mnt/data` that contains all data.
The main sources of input data are described in the following sections.

#### Exome data (FASTQ)

We have exome data for three individuals. These data were generated using a kit that is intended for humans but
appears to work fairly well for other, non-human, Great Apes as well. The data were originally posted on a server
at LUMC (for purely historical reasons and in the interest of completeness, the original location was
https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/, but this has been removed), and have since been transferred to 
the data volume. Note that these data are currently under embargo and as such there is no permission whatsoever to 
share these data with third parties. Note also that these data are the original, and hence most valuable component 
of this project, which is why they have been MD5 checksummed (file stored on the instance), and set to READ ONLY in 
order to prevent accidental mistakes. The files are in FASTQ format (Illumina dialect for Phred scores) resulting 
from paired end sequencing, hence for every individual there are two files, which is indicated by the `{1,2}` in 
the file names:

- **Sandra** - `Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R{1,2}_001.fastq.gz`
- **individual XXX** - `Generade_107582_GTTTCG_L007_R{1,2}_001.fastq.gz`
- **individual YYY** - `Generade_V34612_GGCTAC_L007_R{1,2}_001.fastq.gz`

#### Reference genome (FASTA)

Same as previously published research, we use the reference genome [gorGor3.1](http://ensembl.org/Gorilla_gorilla/Info/Index).
The data in fasta format were downloaded from ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF_000151905.1_gorGor3.1//GCF_000151905.1_gorGor3.1_assembly_structure/Primary_Assembly/assembled_chromosomes/FASTA

#### Previously published SNPs (VCF)

To identify the likely origin of our specimens we need to compare their SNPs with those of other, already identified
individuals. To this end we contacted [Chris Tyler-Smith](http://www.sanger.ac.uk/people/directory/tyler-smith-chris),
the senior author on a paper that also took this approach [1]. He indicated that we might have issues pooling our data
with his team's, because our SNPs are exomic and his had gone through a data reduction step that would like cause the
intersection between these data sets to be small. He forwarded us to [Yali Xue](http://www.sanger.ac.uk/people/directory/xue-yali),
who provided us with the data underlying two papers ([2],[3]) that present high-coverage, whole genome sequences of all
different, currently recognized gorilla subspecies. These data were hosted on ftp://ngs.sanger.ac.uk/scratch/project/team19/gorilla_vcfs, where they have since been removed. Now they are under
`data/vcf`, in VCF format. The different samples in these files - quite a few individuals were sequenced - have
identifiers that are prefixed with abbreviations that denote the different subspecies:

- Eastern gorilla (*G. beringei*):
  - `Gbb` - *Gorilla beringei beringei* - Mountain gorilla
  - `Gbg` - *Gorilla beringei graueri* - Eastern lowland gorilla
- Western gorilla (*G. gorilla*):
  - `Ggd` - *Gorilla gorilla diehli* - Cross River gorilla
  - `Ggg` - *Gorilla gorilla gorilla* - Western lowland gorilla

**Note** - Please check if the file extension contains ".bgz". This is a non-standard extension that for reasons unbeknownst 
to us were used by the Sanger centre. This extension creates errors when used with bgzip. If the extension is present, run the
following two commands inside the vcf folder:

```bash
for file in *.bgz; do
    mv "$file" "`basename $file .bgz`.gz"
done

for file in *.bgz.tbi; do
    mv "$file" "`basename $file .bgz.tbi`.gz.tbi"
done
```

After that, the files can be extracted one by one by running `bgzip -d *.gz`.
Once all vcf file are present, you can run `bcftools concat *.vcf > outputname`.
This is create a bulky, concatenated file for all vcf data.

#### References
1. doi:[10.1371/journal.pone.0065066](http://dx.doi.org/10.1371/journal.pone.0065066)
2. doi:[10.1126/science.aaa3952](http://dx.doi.org/10.1126/science.aaa3952)
3. doi:[10.1038/nature12228](http://dx.doi.org/10.1038/nature12228)
