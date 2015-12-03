#!/bin/bash

# work in progres variables.
# must be changed for the actual pipeline.
path_output=/mnt/data/pipeline/output_sickle/


echo "Start script: $(date +%T)"
read -p "Enter name for outputdirectory: " usrRunname
outputDir=${path_output}${usrRunname}

while
  [ -d ${outputDir} ]
do
  read -p "Directory already exists. Enter a different name: " usrRunname
  outputDir=${path_output}${usrRunname}
done

mkdir ${outputDir}

echo "Start pipeline: $(date +%T)"
# hier eerste script voor pipeline aanroepen.
# denk aan het meegeven van de outputdir!

