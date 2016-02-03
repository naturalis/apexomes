#!/bin/bash
Trim=$1
# Declaration of variables.
RefGenome="$(cat ../config.txt | egrep -v '#' | head -n 1)"
ResultDir="$(cat ../config.txt | egrep -v '#' | head -n 2 | tail -n 1)"
arDataDir="$(cat ../config.txt | egrep -v '#' | awk '{if(NR>2)print}')"
for monkey in ${arDataDir}
do
    # For each sample in the Gorilla data
    # get sample name with basename
    name="$( basename ${monkey} )"
    # Convert samplename to path
    samplepath=${ResultDir}/${name}
    # Create sub directory in result directory if
    # directory doesn't excist.
    if [ ! -d "${samplepath}" ]
    then
        mkdir ${samplepath}
    fi
    # If user specified trimming. The trimscript will
    # be called from here.
    if [ "${Trim}" = 'y' ]
    then
        # Please specify trim command.
    else
        # Move reads to resultfolder so mapping script
        # can grab the files and place result files on
        # right location.
        # PLEASE CHECK COMMAND
        #"$( cp ${monkey}/*.gz ${samplepath}/ )"
    fi
    #./
    
done

#outputDir=$1
#inFile1=$2
#inFile2=$3
#outputPath=$4
#usrOutputDir=$5


#echo ${outputDir}


#echo "${outputDir}"
#echo "${inFile1}"
#echo "${inFile2}"
#echo "${outputPath}"
#echo "${usrOutputDir}"

#bash ./Trimmer.sh ${ResultDir} ${inFile1} ${inFile2}

echo "trim klaar"
#sleep 10
#bash ./bwa.sh ${outputPath} ${usrOutputDir} ${outputDir}


echo "End pipeline: $(date +%T)"
