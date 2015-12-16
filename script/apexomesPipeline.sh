#!/bin/bash

outputDir=$1
inFile1=$2
inFile2=$3
outputPath=$4
usrOutputDir=$5

last_char=${outputDir:$((${#outputDir}-1)):${#outputDir}}
if [[ "${last_char}" != / ]]
then
  outputDir=${outputDir}/
fi
echo ${outputDir}

bash ./Trimmer.sh ${outputDir} ${inFile1} ${inFile2}
bash ./bwa.sh ${outputPath} ${usrOutputDir}

echo "End pipeline: $(date +%T)"
