#!/bin/bash
# It is easier to maintain a different script for the reference genome, because this uses a different checksum command, and
# gets the files feeded from the checksum file prodivded by ensembl.
# The script is not tested with BWA. There is room to update for the files to be BWA ready.
# Not species specific.
function WithoutCheckSums(){
	filelist="$(  echo ${weblist} | tr ' ' '\n' | egrep  ".*\.(.*).dna.chromosome.(((1|2)|[0-9])|(X|Y))"  | tr "\n" " " )"
	while read  line
	do
		wget ${line}
		
	done < <(echo "$filelist")
	gunzip *
}

function WithCheckSums(){
	# Downloading checksums
	`wget ${BaseUrl}"CHECKSUMS"`
	# I advice doing this with a simple egrep and exit if there is any file in the failedChromosomes.
	fastalist="$(cat checksums | egrep  ".*\.(.*).dna.chromosome.(((1|2)|[0-9])|(X|Y))" | awk '{ print $0} ') "
	while read  line
	do
		name="$(echo $line | awk '{print $3}')"
		# if the file does not exists, then do code.
		if [ ! -e "${name}" ]
		then
			#Download file.
			`wget ${BaseUrl}${name}`
			# create a checksum for the downloaded file.
			check="$(sum ${name} | awk '{print $1, $2}') "
			# get colums with checksums from line.
			checkfromfile="$(echo ${line} | awk '{print $1, $2}')"
			
			check2="$(echo "${check}" | egrep "${checkfromfile}")"
			if [ "${check}" == "${checkfromfile}" ] || [ "${#check2}" -gt 0 ]
			then
				# if the checksum matches, then extract file from gz.
				`gunzip ${name}`
			
			else
				# File for listing failed downloads. This file can be checked in the complete pipeline for missing files. 
				# if file doesn't matches, extend the failedChromosomes list.
				echo ${name} >> failedChromosomes
				rm ${name}
			fi
		fi
	done < <(echo "$fastalist")
}


#Script downloads the genome from the Gorilla. Location can be provided in the variable below.
#BaseUrl="ftp://ftp.ensembl.org/pub/release-82/fasta/gorilla_gorilla/dna/" # with checksums
#BaseUrl="ftp://ftp.ensembl.org/pub/release-58/fasta/gorilla_gorilla/dna/"
#BaseUrl="ftp://ftp.ensembl.org/pub/release-82/fasta/homo_sapiens/dna/"
BaseUrl="http://ftp.ensembl.org/pub/release-71/fasta/gorilla_gorilla/dna/"
# FILL ME IN FIRST!
# Could be prodivded by main pipeline.
Path="/media/sf_D_DRIVE/ape/dl_gen/"
version="$(echo $BaseUrl | awk -F '/' '{print $5}')"
Species="$(echo $BaseUrl | awk -F '/' '{print $7}')"
DIRNAME=${Path}Refgenome_${version}_${Species}
`mkdir ${DIRNAME}`
# for saving the files and using local paths.
cd ${DIRNAME}
wget ${BaseUrl}
weblist="$(cat index.html | egrep "a href" | awk -F "<" '{ print $2 }' |  awk -F '"' '{ print $2 }' )"
webcheck="$(echo ${weblist} | egrep "CHECKSUMS" )"
rm index.html
if [ "${webcheck}"  ]
then
	# if checksums available, then do downloading with checksums.
	WithCheckSums
else
	WithoutCheckSums
fi


echo "Done downloading files."
