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
