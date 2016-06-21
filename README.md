# apexomes
Scripts and config files for mapping and analyzing exomes of the great apes.

These scripts and config files will be used on an instance of Naturalis's [private cloud](https://stack.naturalis.nl).
The cloud instance will mount a separate data volume that will contain reference data, such as the 
[gorilla reference genome](ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF_000151905.1_gorGor3.1//GCF_000151905.1_gorGor3.1_assembly_structure/Primary_Assembly/assembled_chromosomes/FASTA) and the exome reads, which are currently, temporarily, hosted
on the following locations:

- https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/Generade_107582_GTTTCG_L007_R1_001.fastq.gz
- https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/Generade_107582_GTTTCG_L007_R2_001.fastq.gz
- https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R1_001.fastq.gz
- https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R2_001.fastq.gz
- https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/Generade_V34612_GGCTAC_L007_R1_001.fastq.gz
- https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/Generade_V34612_GGCTAC_L007_R2_001.fastq.gz

Note that these data are currently under embargo and as such there is no permission whatsoever to share these data with
third parties.

# further reading
- doi:[10.1126/science.aaa3952](http://dx.doi.org/10.1126/science.aaa3952)
- doi:[10.1371/journal.pone.0065066](http://dx.doi.org/10.1371/journal.pone.0065066)
- doi:[10.1038/nature12228](http://dx.doi.org/10.1038/nature12228)


# gorilla subspecies abbreviations 
Used abbreviations for the different gorilla subspecies
- Eastern gorilla (G. beringei):
  - Gbb - Gorilla beringei beringei - Mountain gorilla
  - Gbg - Gorilla beringei graueri - Eastern lowland gorilla
- Western gorilla (G. gorilla):
  - Ggd - Gorilla gorilla diehli - Cross River gorilla
  - Ggg - Gorilla gorilla gorilla - Western lowland gorilla


=====

# Description
The apexomes project is a Generade collaboration between LUMC, Hogeschool Leiden, Museum Boerhaave and Naturalis Biodiversity Center. 
In this project a pipeline is built to identify the subspecies of a gorilla museum specimen by comparing the genetic 
variance with other gorilla data. The pipeline has only been tested with gorilla data, but shouldn’t be organism-specific. 
The pipeline has been running in a cloud instance on Naturalis's OpenStack environment. 

# Dependencies
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

# Input
### *Data used*
The pipeline works with paired end reads. It needs exactly two files, one forward and one reverse. It also uses a 
(downloaded) reference genome.
### *config.txt*
The settings for the pipeline can be stored in the file *config.txt*. 
It stores the location of the reference genome, the location of the reads and the desired output directories.
This file should be edited before running the pipeline.

# Running the pipeline
### *How to start*
The pipeline can be started by running the pipeline main script: *startPipeline* stored in the apexomes directory.
All other scripts used in the pipeline are stored in the directory *script*. 

### *Additional scripts*
The directory *script* contains a subdirectory *additionalScripts*. This directory contains other scripts that were used in 
this project, but are not part of the actual pipeline.

Clustering could be done with many combinations with datasets. For beginning with clustering you must determine what exactly you want
to cluster. For example: Do you want to use a reference? Do you want to have a coding reference or raw reference? 

# Clustering with coding reference:
If you want to have a dataset with coding genes. You have to use the Extract-cdna-headers.bash script.
This script can be found in  http://www.github.com/naturalis/apexomes/script/VcfFilter/Extract-cdna-headers.bash
Please change the input directory variable "inputvcfdir" and change the output directory variable "outputdir"
to the right directories. Go to concat reference for further instructions.

# Clustering with full reference:
Please check if the file extenstion contains ".bgz". This is a non existing extenstion that creates errors. If the extenstion
is present. Run the following two commands:

```bash
for file in *.bgz; do
    mv "$file" "`basename $file .bgz`.gz"
done


for file in *.bgz.tbi; do
    mv "$file" "`basename $file .bgz.tbi`.gz.tbi"
done
```

After that, run `bgzip -d *.gz` for each file to extract everything one by one. After that, go to concat reference.


# Concat reference:
If all vcf file are represent. Run `bcftools concat *.vcf > outputname`.
This is to create a bulky file for all vcf data.

# Merge reference with your data:
This step is repettive. First you have to compress the two vcf files you want to merge: For example reference.vcf and Auzoux.vcf
First you have to run:
``` bash
bgzip reference.vcf
tabix -p vcf reference.vcf.gz
bgzip Auzoux.vcf
tabix -p vcf Auzoux.vcf.gz
```
This is to compress the files and create indexes so they can be used for merging. The merging can be done by
bcftools merge reference.vcf.gz Auzoux.vcf.gz > AuzouxMergedWithRef.vcf
This will create a large file for the Auzoux Gorilla and the reference. If you want to add more gorillas, then you have
to run de bgzip for the new large reference file and your next Gorilla. If you have added all the gorillas you want, go to Clustering.

# Clustering:
To do clustering you have to convert the vcf file to the plink format file. This can be done by:
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
