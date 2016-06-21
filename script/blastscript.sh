#!/bin/bash
# *** THIS IS AN ADDITIONAL SCRIPT NOT USED BY THE PIPELINE ***

#Script using blast+.
#Uses the remote ncbi database to blast reads.
#Looks at the single best hit and notes the taxa id.

#Refers to the map where blast+ is installed.
/home/ubuntu/blast+/ncbi-blast-2.2.31+/bin/blastn \
#Specifies what kind of blast is performed.
-task blastn \
#Defines the used database.
-db nt \
#Refers the path where data is found for input.
-query /mnt/data/Boer_Azoux/blast_azoux_R2.fa \
#Refers the path where data is put as output.
-out /mnt/data/pipeline/output_blast/blast_results.txt \
#Parameter that difines how many blast hits should be stored per read.
-max_target_seqs 1 \
#Defines the output format. staxids let you directly get the taxa ids.
-outfmt '6 staxids' \
#Enables the script to use the remote ncbi database.
-remote
