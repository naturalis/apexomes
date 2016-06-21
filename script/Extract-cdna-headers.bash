#!/bin/bash
# This script loops through all the comprimised vcf files in a folder and extracts them
# It can also filter for exome snp's by using the FilterCdnaSNPsFromVcf python script.

#CHANGE ME!
inputvcfdir="/media/sf_D_DRIVE/ape/vcf/Sanger"
#CHANGE ME!
outputdir="/media/sf_D_DRIVE/ape/vcf/output"
if [ ! -e "${inputvcfdir}/Gorilla_gorilla.gorGor3.1.71.cdna.all.fa" 	]
then
    #For downloading the coding regions.
	wget -P ${inputvcfdir} "http://ftp.ensembl.org/pub/release-71/fasta/gorilla_gorilla/cdna/Gorilla_gorilla.gorGor3.1.71.cdna.all.fa.gz"
	gunzip ${inputvcfdir}/Gorilla_gorilla.gorGor3.1.71.cdna.all.fa.gz
fi


filelist="$(ls ${inputvcfdir}/*.bgz)"
for filename in ${filelist}
do
    # Naming new file. This is to change bgz to gz.
    newfile="${filename::-3}gz"
	# Change extention to use bgzip
    mv ${filename} ${newfile}
	# Decompressing file.
	bgzip -d ${newfile}
	#Name of the vcf file.
	newvcf=${newfile::-3}
	searchvar="$( echo ${filename} | egrep -o "[[:digit:]]([[:digit:]]||a|b)\.vcf" | awk -F '.' '{print $1}')"
	# The list contains all positions of coding dna.
	list="$(cat ${inputvcfdir}/Gorilla_gorilla.gorGor3.1.71.cdna.all.fa | egrep  ">.*rGor3.1:${searchvar}:"  | awk -F ':' '{print $5"-"$6}' | sort -k1 -n)"
	# Write coding file to new file.
	./FilterCdnaSNPsFromVcf.py -exome "${list}" ${newvcf} > ${outputdir}/codingfiltered.chr${searchvar}.vcf
	# compress old file.
	bgzip ${newvcf}
	# Bring it back to the old state
	mv ${newfile} ${filename}
	# Remove the old file
	rm ${newvcf}
	# And nobody noticed what happend with the file....
	echo "Chromosome ${searchvar} is done." 
done

echo "Script has completed the extraction."
