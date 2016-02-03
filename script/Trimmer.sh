#!/bin/sh

echo "Start trimming: $(date +%T)"

#output_path=/mnt/data/pipeline/output_sickle/TestaapjeBLA/
output_path=$1
input_path=$2
reads=(ls ${input_path}/*.fastq.gz)
input1=${reads[1]}
input2=${reads[2]}


~/sickle/sickle pe -t sanger -g -f ${input1} -r ${input2} \
  -o ${output_path}/out_trimmed_p1.fastq.gz -p ${output_path}/out_trimmed_p2.fastq.gz \
  -s ${output_path}/out_trimmed_single.fastq.gz

echo "Done trimming: $(date +%T)"
