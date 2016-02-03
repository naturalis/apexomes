#!/bin/bash
# Might be needing a line in config for the reference vcf files.

# From the config.txt files the corresponding lines are added to the right variables.
RefGenome="$(cat config.txt | egrep -v '#' | head -n 1)"
ResultDir="$(cat config.txt | egrep -v '#' | head -n 2 | tail -n 1)"
arDataDir="$(cat config.txt | egrep -v '#' | awk '{if(NR>2)print}')"
echo "The following settings where found:"
echo "Reference genome:"
echo ${RefGenome}
echo "Result directory:"
echo ${ResultDir}
echo "Data directories:"
printf '%s\n' "${arDataDir[@]}"
yesno="y n"
# If the user states an incorrect config datafile, the script will close.
echo "Is this correct?"
select ant in ${yesno}
    do
    if [ "${REPLY,,}" = 'y' ]
    then
        break
    elif [ "${REPLY,,}" = 'n' ]
    then
        echo "Please check your config.txt file and then run the pipeline again"
        exit
    fi
done
# If the result directory excists and the user doesn't want to override the data,
# the script will close. If the directory doesn't excists, the script create the
# result directory.
if [ -d "${ResultDir}" ]
then
    echo "Result directory already exists. Do you want to overwrite the files in it?"
    select ans in ${yesno}
    do
        if [ "${REPLY,,}" = 'y' ]
        then
            break
        elif [ "${REPLY,,}" = 'n' ]
        then
            echo "Please check your config.txt file and change the result directory"
            exit
        fi
    done
else
    mkdir ${ResultDir}
fi
# Script asks if the user want to trim the input files. Result will
# be stored in the Trim option.
echo "Do you want to trim the reads?"
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

echo "Start pipeline: $(date +%T)"
cd script
bash apexomesPipeline.sh ${Trim}
