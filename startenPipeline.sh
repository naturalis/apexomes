#!/bin/bash

# work in progres variables.
# must be changed for the actual pipeline.
#path_output=/mnt/data/NewRefPipeline
RefGenome="$(cat config.txt | egrep -v '#' | head -n 1)"
echo "The following settings where found:"
echo ${RefGenome}
yesno="y n"
echo "Is this correct?"
select ant in ${yesno}
    do
	if [ "${REPLY,,}" = 'y' ]
	then
	    break
    else if [ "${REPLY,,}" = 'n' ]
    then
        echo "Please check your config.txt file and then run the pipeline again"
        exit
	fi
    done

echo "Do you want to trim the reads?"
#yesno="y n"
select ans in ${yesno}
    do
	if [ "${REPLY,,}" = 'y' ] || [ "${REPLY,,}" = 'n' ]
	
	then
	    Trim="${REPLY,,}"
	    break
        else
            echo "Please select yes or no"
	fi	
    done
echo "Start script: $(date +%T)"
#read -p "Enter name for outputdirectory: " usrRunname
usrRunname=SandraNew
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
# Nodig voor het trimmen. 13-1-2016 is er geen trimming gebruikt.
inFile1=/mnt/data/Blij_Sandra/Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R1_001.fastq.gz
inFile2=/mnt/data/Blij_Sandra/Generade_Gorilla-gorilla-gorilla_F_Sandra_EAZA-Studbook-9_L007_R2_001.fastq.gz

# debug
echo ${Trim}

echo "Start pipeline: $(date +%T)"
# hier eerste script voor pipeline aanroepen.
# denk aan het meegeven van de outputdir!
#bash apexomesPipeline.sh ${outputDir} ${inFile1} ${inFile2} ${path_output} ${usrRunname}
