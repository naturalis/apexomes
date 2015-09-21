#!/bin/bash

# script to download the reads. Note that the location of the data volume (and subdir where the data goes) 
# first HAVE to be defined. Note also that this script is not yet tested, please check that the files list
# is defined correctly.

# DEFINE ME FIRST!!!! THIS NEEDS TO BE A PATH THAT POINTS TO THE DIRECTORY WHERE
# THE READS WILL BE STORED
DATADIR=

# base location from whence we will download the files
BASEURL=https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/

# list of files
FILES=Generade_107582_GTTTCG_L007_R1_001.fastq.gz\ Generade_107582_GTTTCG_L007_R2_001.fastq.gz\ Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R1_001.fastq.gz\
\ Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R2_001.fastq.gz\ Generade_Pongo-abelii_F_Maria_EAZA-Studbook-2716_L007_R1_001.fastq.gz\
\ Generade_Pongo-abelii_F_Maria_EAZA-Studbook-2716_L007_R2_001.fastq.gz\ Generade_Pongo-abelii_M_Buchen_RMNH-MAM-544_L007_R1_001.fastq.gz\
\ Generade_Pongo-abelii_M_Buchen_RMNH-MAM-544_L007_R2_001.fastq.gz\ Generade_Pongo-pygmaeus_M_Aram_RNMN-MAM-37741_L007_R1_001.fastq.gz\
\ Generade_Pongo-pygmaeus_M_Aram_RNMN-MAM-37741_L007_R2_001.fastq.gz\ Generade_RNMN_MAM_37740_TAGCTT_L007_R1_001.fastq.gz\
\ Generade_RNMN_MAM_37740_TAGCTT_L007_R2_001.fastq.gz\ Generade_V34612_GGCTAC_L007_R1_001.fastq.gz\
\ Generade_V34612_GGCTAC_L007_R2_001.fastq.gz

# check if $DATADIR is a directory
if [ -d "$DATADIR" ]; then

  # iterate over files
  for FILE in $FILES; do
  
    # check if file has not yet been downloaded
    if [ ! -e "$DATADIR/$FILE" ]; then
    
      # download the file using wget. this program is probably available on our cloud instance
      wget -O "$DATADIR/$FILE" "$BASEURL/$FILE"
    else
    
      # no need to do the download again if already done
      echo "$FILE already downloaded"
    fi
  done
else 

  # data dir not defined, or not a directory, or not mounted correctly.
  echo "ERROR: The DATADIR variable does not point to a directory. This script needs to be fixed before we can continue."
fi
