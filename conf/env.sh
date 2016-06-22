#!/bin/bash
# This file sets up the environment variables for the analysis. This so that we 
# don't have to fiddle with command line arguments or hack into the config.txt.

# The location of the data volume
export DATADIR=/mnt/data

# Where the input data are located
export INDIR=$DATADIR/input

# The location of the reference genome, as unzipped FASTA
export REFERENCE=$INDIR/fasta/Gorilla_gorilla.gorGor3.1.71.dna.toplevel.fa

# The location of the VCF files
export VCFDIR=$INDIR/vcf

# The location of the FASTQ files
export FASTQDIR=$INDIR/fastq
