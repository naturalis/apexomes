#!/bin/bash
# Declaration of variables.
RefGenome="$(cat config.txt | egrep -v '#' | head -n 1)"
ResultDir="$(cat config.txt | egrep -v '#' | head -n 2 | tail -n 1)"
arDataDir="$(cat config.txt | egrep -v '#' | awk '{if(NR>2)print}')"
for monkey in ${arDataDir}
do
    echo ${monkey}
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
