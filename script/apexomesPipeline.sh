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
        bash ./Trimmer.sh ${samplepath} ${monkey}

	trimextension = "out_trimmed_p"
    else
        # Move reads to resultfolder so mapping script
        # can grab the files and place result files on
        # right location.
        # PLEASE CHECK COMMAND
        #"$( cp ${monkey}/*.gz ${samplepath}/ )"
	trimextension = ""
    fi
    # Wat moet hier?
    # outputhPath = ${ResultDir} ${useroutputdir} = ${name} ${outputDir} = samplepath
    #bash ./bwa.sh ${outputPath} ${usrOutputDIr} ${outputDir} ${trimextension} ${RefGenome}
    #bash ./bwa.sh ${ResultDir} ${name} ${samplepath} ${trimextension} ${RefGenome}
    # After mapping it is variant calling time...
    ./variantcalling.sh ${RefGenome} ${samplepath}
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
#bash ./bwa.sh ${outputPath} ${usrOutputDir} ${outputDir} ${trimextension} ${RefGenome}
./bwa.sh

echo "End pipeline: $(date +%T)"
