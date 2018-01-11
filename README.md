# The `apexomes` project

![Auzoux paper mache gorilla        photo: G.Grob - Boerhaave museum](https://github.com/naturalis/apexomes/blob/master/Auz_Gor_photo-Grob.jpg)

The apexomes project is a [Generade](https://generade.nl/) collaboration between [LUMC](https://www.lumc.nl/), 
[Hogeschool Leiden](https://www.hsleiden.nl), [Museum Boerhaave](http://www.museumboerhaave.nl/) and 
[Naturalis Biodiversity Center](http://www.naturalis.nl). In this project a pipeline is built to identify the 
subspecies of a gorilla museum specimen by comparing the specimen's genetic variation with other, previously 
identified gorilla individuals from all known subspecies. The genetic variation data are generated by performing 
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
 - Vcftools (0.1.11): sudo apt-get install vcftools
 - BLAST+ (2.2.28+): sudo apt-get install ncbi-blast+
 - PLINK (1.90b3.37) : https://www.cog-genomics.org/static/bin/plink160607/plink_linux_x86_64.zip
 -  BCFTOOLS (1.3.1): sudo apt-get install bcftools 

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
- **Thirza** - `Generade_107582_GTTTCG_L007_R{1,2}_001.fastq.gz`
- **Azoux** - `Generade_V34612_GGCTAC_L007_R{1,2}_001.fastq.gz`

#### Reference genome (FASTA)

Same as previously published research, we use the reference *Gorilla gorilla* genome 
[gorGor3.1, release 71](http://ensembl.org/Gorilla_gorilla/Info/Index).
The data in fasta format were downloaded from http://ftp.ensembl.org/pub/release-71/fasta/gorilla_gorilla/dna/

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
  - `Gbb` - *Gorilla beringei beringei* - [Mountain gorilla](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=1159185)
  - `Gbg` - *Gorilla beringei graueri* - [Eastern lowland gorilla](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=46359)
- Western gorilla (*G. gorilla*):
  - `Ggd` - *Gorilla gorilla diehli* - [Cross River gorilla](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=406788)
  - `Ggg` - *Gorilla gorilla gorilla* - [Western lowland gorilla](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=9595)

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

After the pipeline is finished you will have a VCF file to use for further downstream analysis, i.e. clustering
of the specimen with other reference specimens. Clustering can be done with many combinations with datasets. To begin 
with clustering you must determine what exactly you want to cluster. For example: Do you want to use a reference? 
Do you want to have a coding reference or raw reference? 

#### Reduce reference to coding only
To extract 'coding genes' (i.e. exomic loci) from the dataset ('Reference.vcf'), use the [Extract-cdna-headers.bash](script/Extract-cdna-headers.bash) script. Please change the input directory variable 
"inputvcfdir" and change the output directory variable "outputdir" to the right directories.

#### Merge reference with obtained data
Compress and index all the vcf files that need to be merged:
``` bash
# compress and index the reference vcf
bgzip reference.vcf
tabix -p vcf reference.vcf.gz
# compress and index the individual vcfs
#Sandra
bgzip Sandra.vcf
tabix -p vcf Sandra.vcf.gz
#Thirza
bgzip Thirza.vcf
tabix -p vcf Thirza.vcf.gz
#Auzoux
bgzip Auzoux.vcf
tabix -p vcf Auzoux.vcf.gz
```
To merge the above vcfs:
``` bash
bcftools merge reference.vcf.gz Sandra.vcf.gz Thirza.vcf.gz Auzoux.vcf.gz > Ref_STA.vcf
```
This will create a large vcf file including data for both the reference gorillas and the specimens from this study.

#### Selection of SNP positions **(optional)**
Even though the (genomic) dataset of Xue et al. (Ref. #3) was filtered for exomic loci (**Merge reference with obtained data**), a substantial number of SNPs did not overlap with this study. It is currently unclear what causes this discrepancy. For verification purposes, one specimen, a.k.a. Sandra, was included in both studies. SNP positions that showed a mismatch between both Sandras were excluded in order to 'normalise' the merged (vcf) dataset.

Create a `'--positions'` file (to be used with vcftools subsequently) that excludes empty SNP positions and includes only those positions for which both 'Sandras' are identical
``` bash
# Determine the vcf header line number:
head -n100 Ref_STA.vcf | cat -n | egrep "CHROM" | awk '{print $1}'
# For large vcfs its much faster to exclude meta-information based on header line position then by 'egrep -v "^##" FILENAME.vcf'

# select SNP positions for which both Sandras are identical:
tail -n +95 Ref_STA.vcf | grep -v ":.:.:.:.:.:" | awk '{print $1,$2,$32,$54,$55,$56}' | awk -F":" '{print $1,$7,$13,$19}' | awk '{print $1,$2,$3,$5,$7,$9}' |  awk '{if ($3==$4) print $0}' | awk 'BEGIN{print "CHROM\tPOS"};{print $1"\t"$2}' > SNP.txt
# exclude Meta-information lines | remove empty SNPs (do not use egrep here..) | select the columns for Gene, Position, Sandra_Xue and the three samples from this study (the header is still informative; see "quickly determine column positions" below) | use ":" to separate by genotype (GT) field | select columns for Gene, Position and Genotype | if the GT values for both Sandras are identical keep line (the header will dissapear) | format output > save tab separated text file (to be called with the --positions flag later in vcftools)

#"quickly determine column positions":
head -n100 Ref_STA.vcf | egrep "CHROM" | tr '\t' '\n' | cat -n 
(optional): | egrep "CHROM|POS|Sandra|Thirza|Azoux")
```
Create a new 'normalised' VCF based on the selected SNP positions ('--postions' file):
``` bash
vcftools --vcf  Ref_STA.vcf --positions SNP.txt --recode
#it doesn't seem possible to provide a name for the outfile, so choose a meaningful name:
mv out.recode.vcf Ref_STA_select.vcf
```
#### Clustering
Generate an **identity-by-descent** report:
``` bash
plink --vcf Ref_STA_select.vcf --double-id --allow-extra-chr --genome --noweb --allow-no-sex --out OUTPUTFILE.raw
# Using '--allow-extra-chr' prevents SNP positions on chromosomes with non-standard numbers (such as 2a and 2b) from being disregarded.
```
Perform **multi dimensional scaling (MDS)** analysis:
``` bash
plink --vcf Ref_STA_select.vcf --double-id --allow-extra-chr --read-genome OUTPUTFILE.raw.genome --cluster --mds-plot 2 --noweb
# the output file (used hereafter for plot) is plink.mds
# to check that the data has been normalised, ie. both Sandras now indeed specify the same point:
egrep "Sandra" plink.mds
```
The result (plink.mds) can be visualised in R using:
``` r
setwd("path/to/location")
# set working directory to the location of plink.mds
d <- read.table("plink.mds", h=T)
d$pop = factor(c(rep("GBB", 7), rep("GBG", 9), rep("GGD", 1), rep("GGG", 27), rep("Sandra", 1), rep("Thirza", 1), rep("Auzoux", 1)))
d$col = factor(c(rep("red", 7), rep("green", 9), rep("pink", 1), rep("blue", 27), rep("orange", 1), rep("yellow", 1), rep("black", 1)))
plot(d$C1, d$C2, col=as.character(d$col), pch=19, xlab="PC 1", ylab="PC 2", main = "MDS: Auzoux, Blijdorp and Gorilla ssp")
legend("topleft", c("GBB Mountain East", "GBG Lowland East", "GGD Cross River West", "GGG Lowland West","Sandra Blijdorp","Thirza Blijdorp","Azoux Gabon?"), pch=19, col=c("red","green","pink","blue","orange","yellow","black"), cex=0.8)
dev.copy2pdf(file="Gorilla_MDS.pdf", width = 7, height = 8)
```
<a href="url"><img src="https://cloud.githubusercontent.com/assets/9463723/16446644/f8d36cfe-3de8-11e6-9b74-e39440d9dbfd.png" height="600" width="525" ></a>

This MDS plot indicates a potential association between the 'Auzoux' specimen and the Cross River gorilla. Assignment of 'Auzoux' to the Western gorilla, *Gorilla gorilla*, is in agreement with its presumed collection locality of Gabon. Now it has been shown that all three individuals (Sandra, Thirza, 'Auzoux') belong to the Western gorilla, more SNP positions might become available by excluding Eastern gorilla ( *Gorilla beringei* ) specimens.

To remove *Gorilla beringei* ssp. from Ref_STA.vcf:
``` bash
vcf-subset -c Ggd-F-B646_Nyango,Ggg-F-9749_Kowali,Ggg-M-9750_Azizi,Ggg-F-9751_Bulera,Ggg-F-9752_Suzie,Ggg-F-9753_Kokomo,Ggg-F-A930_Sandra,Ggg-M-A931_Banjo,Ggg-F-A932_Mimi,Ggg-F-A933_Dian,Ggg-F-A934_Delphi,Ggg-F-A936_Coco,Ggg-F-A937_Kolo,Ggg-F-A962_Amani,Ggg-F-B642_Akiba_Beri,Ggg-F-B643_Choomba,Ggg-F-B644_Paki,Ggg-F-B647_Anthal,Ggg-F-B650_Katie,Ggg-F-KB3782_Vila,Ggg-F-KB3784_Dolly,Ggg-F-KB4986_Katie,Ggg-F-KB5792_Carolyn,Ggg-F-KB5852_Helen,Ggg-F-KB6039_Oko,Ggg-F-KB7973_Porta,Ggg-M-X00108_Abe,Ggg-M-X00109_Tzambo,Blij_Sandra,Blij_Thirza,Boer_Azoux Ref_STA.vcf > West_only.vcf
```
For subsequent **SNP selection** and **Clustering** see paragraphs above.
Notice that by removing the eastern gorilla specimens, the column numbers of the taxa also changed, ie:
``` bash
tail -n +96 West_only.vcf | grep -v ":.:.:.:.:.:" | awk '{print $1,$2,$16,$38,$39,$40}' | awk -F":" '{print $1,$7,$13,$19}' | awk '{print $1,$2,$3,$5,$7,$9}' | awk '{if ($3==$4) print $0}' | awk 'BEGIN{print "CHROM\tPOS"};{print $1"\t"$2}' > SNP_West_only.txt
```
The updated R script:
``` r
setwd("path/to/location")
# set working directory to the location of plink.mds
d$pop = factor(c(rep("GGD", 1), rep("GGG", 27), rep("Sandra", 1), rep("Thirza", 1), rep("Auzoux", 1)))
d$col = factor(c(rep("pink", 1), rep("blue", 27), rep("orange", 1), rep("yellow", 1), rep("black", 1)))
plot(d$C1, d$C2, col=as.character(d$col), pch=19, xlab="PC 1", ylab="PC 2", main = "MDS: Auzoux, Blijdorp and Gorilla West ssp")
legend("topleft", c("GGD Cross River West", "GGG Lowland West","Sandra Blijdorp","Thirza Blijdorp","Azoux Gabon?"), pch=19, col=c("pink","blue","orange","yellow","black"), cex=0.8)
dev.copy2pdf(file="Gorilla_West_MDS.pdf", width = 7, height = 8)
```
<a href="url"><img src="https://cloud.githubusercontent.com/assets/9463723/16446353/63677cec-3de7-11e6-9bae-42a3ef6afa92.png" height="600" width="525" ></a>

This MDS plot depicts the Cross River gorilla within (not separated from) the Western lowland point cloud and shows no association with 'Auzoux'. The three specimens of this study now seem separated from this point cloud (GGG), but notice that the orange dot for Sandra is a blue dot as well. In our opinion these data merely add to the known diversity of the Western lowland gorilla.  
Because the association between Cross River and 'Auzoux' was only observed in the first MDS plot, we decided to look if the association was random or whether it got supported by particular chromosomes. In case of a methodological error we would expect to observe the three specimens together, but separated from the (GGG) point cloud, repeatedly.

#### SNPs per chromosome
Starting from 'Ref_STA_select.vcf' the following BASH scripts will create an R script that generates MDS plots (saved as PDF) for each chromosome:  
`1.snps.per.chrom.sh`
>\# creates '--positions' files (for vcftools) and subsequent VCFs per chromosome  
>\# output: pos_files and vcf_files folders  

`2.vcf2mds.sh`
>\# converts (a folder of) VCFs to MDS files  
>\# output: mds_chrom and mds_sum folders  

`3.mds2R.sh`
>\# creates an R script to visualise the output of multiple MDS analyses  
>\# output: script_mds.R  

`0.run_123.sh`
>\# executes the three scripts above consecutively  

The above scripts were written as a temporary solution to prevent a twenty-three fold repetative task of obtaining an MDS plot for each chromosome. The input file is `name_input_file`.vcf and represents Gorilla (22 chromosomes, incl. 2a 2b). It has to be located in the folder where script 0. or 1. is executed and the header of input.vcf is assumed to be on line 95. To use the scripts for other organisms/VCFs adjust these requirements (snps.per.chrom.sh l.14 and l.18).

The PDFs of the resulting R script are summarized here:
https://github.com/naturalis/apexomes/blob/master/pdf/Sum_chrom_1-7.pdf
https://github.com/naturalis/apexomes/blob/master/pdf/Sum_chrom_8-15.pdf
https://github.com/naturalis/apexomes/blob/master/pdf/Sum_chrom_16-22.pdf

Noticeable plots:
<a href="url"><img src="https://cloud.githubusercontent.com/assets/9463723/16557280/2070a994-41df-11e6-81b2-9d152d122139.png" height="435" width="817" ></a>
Chromosome 8 shows the eastern and western gorillas separated, but neither group allows a distinction between subspecies. Chromosome 17 allows a distinction between the subspecies of _G. beringei_ and indicates much similarity between Cross River and 'Auzoux'.  

#### References
1. Scally, A., Yngvadottir, B., Xue, Y., Ayub, Q., Durbin, R., & Tyler-Smith, C. (2013). A genome-wide survey of genetic variation in gorillas using reduced representation sequencing. PloS one, 8(6), e65066. doi:[10.1371/journal.pone.0065066](http://dx.doi.org/10.1371/journal.pone.0065066)
2. Xue, Y., Prado-Martinez, J., Sudmant, P. H., Narasimhan, V., Ayub, Q., Szpak, M., ... & De Manuel, M. (2015). Mountain gorilla genomes reveal the impact of long-term population decline and inbreeding. Science, 348(6231), 242-245. doi:[10.1126/science.aaa3952](http://dx.doi.org/10.1126/science.aaa3952)
3. Prado-Martinez, J., Sudmant, P. H., Kidd, J. M., Li, H., Kelley, J. L., Lorente-Galdos, B., ... & Cagan, A. (2013). Great ape genetic diversity and population history. Nature, 499(7459), 471-475. doi:[10.1038/nature12228](http://dx.doi.org/10.1038/nature12228)

