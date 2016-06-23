#!/bin/bash
Trim=$1

# Declaration of variables.
RefGenome="$(cat ../config.txt | egrep -v '#' | head -n 1)"
ResultDir="$(cat ../config.txt | egrep -v '#' | head -n 2 | tail -n 1)"
arDataDir="$(cat ../config.txt | egrep -v '#' | awk '{if(NR>2)print}')"
for monkey in ${arDataDir}; do

    # For each sample in the Gorilla data
    # get sample name with basename
    name="$( basename ${monkey} )"

    # Convert samplename to path
    samplepath=${ResultDir}/${name}

    # Create sub directory in result directory if
    # directory doesn't excist.
    if [ ! -d "${samplepath}" ]; then
        mkdir ${samplepath}
    fi
    
    # If user specified trimming. The trimscript will
    # be called from here.
    if [ "${Trim}" = 'y' ]; then
    
        # Please specify trim command.
        bash ./trimmer.sh ${samplepath} ${monkey}
	trimextension="out_trimmed_p"
    else
    
        # Move reads to resultfolder so mapping script
        # can grab the files and place result files on
        # right location.
        # PLEASE CHECK COMMAND
        cp ${monkey}/*.gz ${samplepath}/
        sleep 10
	trimextension="a"
    fi
    
    # Do the mapping
    bash ./bwa.sh ${ResultDir} ${name} ${samplepath} ${trimextension} ${RefGenome}
    
    # After mapping it is variant calling time...
    bash ./variantcalling.sh ${RefGenome} ${samplepath}
done

echo "End pipeline: $(date +%T)"
