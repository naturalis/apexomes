#!/bin/bash

/home/ubuntu/blast+/ncbi-blast-2.2.31+/bin/blastn \
-task blastn \
-db nt \
-query /mnt/data/Boer_Azoux/blast_azoux_R2.fa \
-out /mnt/data/pipeline/output_blast/blast_results.txt \
-max_target_seqs 1 \
-outfmt '6 staxids' \
-remote
