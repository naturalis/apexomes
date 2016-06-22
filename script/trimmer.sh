#!/bin/sh

echo "Start trimming: $(date +%T)"

# variables
#output_path=/mnt/data/pipeline/output_sickle/TestaapjeBLA/
output_path=$1
input_path=$2
reads=(ls ${input_path}/*.fastq.gz)
input1=${reads[1]}
input2=${reads[2]}


# trimming command
# pe = Paired end reads are used
# -t = type of quality values used (Illumina, Solexa or Sanger)
# -g = output should be compresed (.gz) format
# -f = inputfile with foreward-reads
# -r = inputfile with reverse-reads
# -o = name of outputfile 1, forward
# -p = name of outputfile 2, revers
# -s = name of outputfile 3, single reads
sickle pe -t sanger -g -f ${input1} -r ${input2} \
  -o ${output_path}/out_trimmed_p1.fastq.gz -p ${output_path}/out_trimmed_p2.fastq.gz \
  -s ${output_path}/out_trimmed_single.fastq.gz

echo "Done trimming: $(date +%T)"
