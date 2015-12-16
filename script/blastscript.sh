#!/bin/bash

/home/ubuntu/blast+/ncbi-blast-2.2.31+/bin/blastn \
-task blastn \
-db nt \
-query /mnt/data/Testaapje/headfile_klein.fa \
-out /mnt/data/pipeline/output_blast/blast_results.out \
-max_target_seqs 1 \
-outfmt 10 \
-remote
