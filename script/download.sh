#!/bin/bash

# script to download the reads. Note that the location of the data volume (and subdir where the data goes) 
# first HAVE to be defined. Note also that this script is not yet tested, so don't assume that this will
# work out of the box. If any corrections need to be made, make sure that they are committed back to the
# repository.

# DEFINE ME FIRST!!!! THIS NEEDS TO BE A PATH THAT POINTS TO THE DIRECTORY WHERE
# THE READS WILL BE STORED
DATADIR=

# base URL location from whence we will download the files
BASEURL=https://barmsijs.lumc.nl/for_Generade/Exomes_Apes/

# list of files
FILES=Generade_107582_GTTTCG_L007_R1_001.fastq.gz\ Generade_107582_GTTTCG_L007_R2_001.fastq.gz\ Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R1_001.fastq.gz\
\ Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R2_001.fastq.gz\ Generade_Pongo-abelii_F_Maria_EAZA-Studbook-2716_L007_R1_001.fastq.gz\
\ Generade_Pongo-abelii_F_Maria_EAZA-Studbook-2716_L007_R2_001.fastq.gz\ Generade_Pongo-abelii_M_Buchen_RMNH-MAM-544_L007_R1_001.fastq.gz\
\ Generade_Pongo-abelii_M_Buchen_RMNH-MAM-544_L007_R2_001.fastq.gz\ Generade_Pongo-pygmaeus_M_Aram_RNMN-MAM-37741_L007_R1_001.fastq.gz\
\ Generade_Pongo-pygmaeus_M_Aram_RNMN-MAM-37741_L007_R2_001.fastq.gz\ Generade_RNMN_MAM_37740_TAGCTT_L007_R1_001.fastq.gz\
\ Generade_RNMN_MAM_37740_TAGCTT_L007_R2_001.fastq.gz\ Generade_V34612_GGCTAC_L007_R1_001.fastq.gz\
\ Generade_V34612_GGCTAC_L007_R2_001.fastq.gz

# list of MD5 checksums
MD5CHECKSUMS=md5checksums

# check if $DATADIR is a directory
if [ -d "$DATADIR" ]; then

  # cd into the data dir, so we can use short paths
  cd $DATADIR

  # download checksums
  if [ ! -e "$MD5CHECKSUMS" ]; then
    
    # download the checksums using wget. this program is probably available on our cloud instance
    # The no check flag ignores an error with the LUMC SSL certificate
    wget --no-check-certificate "$BASEURL/$MD5CHECKSUMS"
  else
  
    # no need to download again if already done
    echo "MD5 checksums file $MD5CHECKSUMS already downloaded"
  fi
  
  # iterate over FASTQ files
  for FILE in $FILES; do
  
    # check if file has not yet been downloaded
    if [ ! -e "$FILE" ]; then
    
      # download the file using wget. this program is probably available on our cloud instance
      wget --no-check-certificate "$BASEURL/$FILE"
      
      # now compare the checksums
      EXPECTED=`grep $FILE $DATADIR/$MD5CHECKSUMS`
      OBSERVED=`md5sum $FILE`
      if [ "$OBSERVED" == "$EXPECTED" ]; then
        echo "Downloaded $FILE successfully, MD5 checksums match"
      else 
        echo "Download of $FILE seems to have failed. The observed and expected MD5 checksums follow:"
        echo "Observed: $OBSERVED"
        echo "Expected: $EXPECTED"
        echo "Will delete failed download"
        rm $FILE
      fi
    else
    
      # no need to do the download again if already done
      echo "$FILE already downloaded"
    fi
  done
  
  # go back to previous location
  cd -
  
else 

  # data dir not defined, or not a directory, or not mounted correctly.
  echo "ERROR: The DATADIR variable does not point to a directory. This script needs to be fixed before we can continue."
fi
