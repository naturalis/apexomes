#!/bin/bash

# work in progres variables.
# must be changed for the actual pipeline.
path_output=/mnt/data/BoerHaave6-1


echo "Start script: $(date +%T)"
#read -p "Enter name for outputdirectory: " usrRunname
usrRunname=Sandra
outputDir=${path_output}/${usrRunname}

#while
#  [ -d ${outputDir} ]
#do
#  read -p "Directory already exists. Enter a different name: " usrRunname
#  outputDir=${path_output}${usrRunname}
#done

#mkdir -p ${outputDir}
#echo "Skip voor 1 keer!"
#read -p "Enter first inputfile: " inFile1
#read -p "Enter second inputfile: " inFile2
inFile1=/mnt/data/Blij_Sandra/Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R1_001.fastq.gz
inFile2=/mnt/data/Blij_Sandra/Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R2_001.fastq.gz



echo "Start pipeline: $(date +%T)"
# hier eerste script voor pipeline aanroepen.
# denk aan het meegeven van de outputdir!
bash apexomesPipeline.sh ${outputDir} ${inFile1} ${inFile2} ${path_output} ${usrRunname}
