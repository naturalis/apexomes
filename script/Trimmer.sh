#!/bin/sh

output_path=/mnt/data/pipeline/output_sickle/
input1=$1
input2=$2

~/sickle/sickle pe -t sanger -f ${input1} -r ${input2} \
  -o ${output_path}out_trimmed_p1.fastq -p ${output_path}out_trimmed_p2.fastq \
  -s ${output_path}out_trimmed_single.fastq

echo "Done trimming: $(date +%T)"
