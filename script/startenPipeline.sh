#!/bin/bash

# work in progres variables.
# must be changed for the actual pipeline.
path_output=/mnt/data/pipeline


echo "Start script: $(date +%T)"
read -p "Enter name for outputdirectory: " usrRunname
outputDir=${path_output}/${usrRunname}

while
  [ -d ${outputDir} ]
do
  read -p "Directory already exists. Enter a different name: " usrRunname
  outputDir=${path_output}${usrRunname}
done

mkdir ${outputDir}

read -p "Enter first inputfile: " inFile1
read -p "Enter second inputfile: " inFile2


echo "Start pipeline: $(date +%T)"
# hier eerste script voor pipeline aanroepen.
# denk aan het meegeven van de outputdir!
bash apexomesPipeline.sh ${outputDir} ${inFile1} ${inFile2} ${path_output} ${usrRunname}
