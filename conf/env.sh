#!/bin/bash
# This file sets up the environment variables for the analysis. This so that we 
# don't have to fiddle with command line arguments or hack into the config.txt.

# The location of the data volume
export DATADIR=/mnt/data

# Where the input data are located
export INDIR=$DATADIR/input

# The reference genome, as unzipped FASTA
export REFERENCE=$INDIR/fasta/Gorilla_gorilla.gorGor3.1.71.dna.toplevel.fa

# The VCF files, split into chromosomes
export VCFDIR=$INDIR/vcf

# The FASTQ files, with subfolders for samples
export FASTQDIR=$INDIR/fastq

# The intermediate results dir
export WORKDIR=$DATADIR/intermediate

# The final results dir
export OUTDIR=$DATADIR/results
