#!/bin/bash

# This script was made by Rutger Vos and altered by Sebastiaan Klein. 
# Small alterations and documentation were done by Sebastiaan de Vriend.
# The original script can be found on github at: https://github.com/naturalis/tomatogenome/bwa.sh

#REFERENCE=/mnt/data/pipeline/Refgenome_release-71_gorilla_gorilla/allCHR.fa
#REFERENCE=/mnt/data/NewRefPipeline/Gorilla_gorilla.gorGor3.1.71.dna.toplevel.fa
REFERENCE=$5
READS=$1
SAMPLES=$2
Trimextension=$4
old_wd=$(pwd)
OUTPUTDIR=$3
cd ${OUTPUTDIR}

echo "Reads ${READS}"
echo "Samples: ${SAMPLES}"


# threads for BWA align
# The current machine has 8 cores available. To keep the system running we have choosen to use 7 cores.
CORES=7

# recreate BWA index if not exists
if [ ! -e $REFERENCE.bwt ]; then
	echo "going to index $REFERENCE"
	# Warning: "-a bwtsw" does not work for short genomes,
	# while "-a is" and "-a div" do not work for long
	# genomes. Please choose "-a" according to the length
	# of the genome.
	echo "$REFERENCE"
	bwa index -a bwtsw $REFERENCE
else
	echo "$REFERENCE already indexed"
fi

# iterate over directories
for SAMPLE in $SAMPLES; do
	echo "going to process sample $SAMPLE"
	echo ${REFERENCE}
	# list the FASTQ files in this dir. this should be
	# two files (paired end)
	if [ "${Trimextension}" = "a" ];then
		ls $READS/$SAMPLE/*.fastq.gz
		FASTQS=`ls $READS/$SAMPLE/*.fastq.gz`
	else
		FASTQS=`ls $READS/$SAMPLE/"$Trimextension"*.fastq.gz`
	fi
	for FASTQ in $FASTQS; do

		# create new name
		LOCALFASTQ=`echo $FASTQ | sed -e 's/.*\///'`
		SAM="$LOCALFASTQ.sam"
	done

	# do bwa sampe if needed
	if [ ! -e $SAM ]; then
		# create paired-end SAM file
		echo "going to run bwa mem $FASTA $FASTQS > $SAM"
		bwa mem -t $CORES $REFERENCE $FASTQS > $SAM
	else
		echo "sam file $SAM already created"
	fi

	# do samtools filter if needed
	if [ ! -e $SAM.filtered ]; then
		# -bS   = input is SAM, output is BAM
		# -F 4  = remove unmapped reads
		# -q 50 = remove reads with mapping qual < 50
		# XXX maybe increase -q?
		echo "going to run samtools view -bS -F 4 -q 50 $SAM > $SAM.filtered"
		samtools view -bS -F 4 -q 50 $SAM > $SAM.filtered
                gzip -9 $SAM
	else
		echo "sam file $SAM.filtered already created"
	fi

	# do samtools sorting if needed
	if [ ! -e $SAM.sorted.bam ]; then

		# sorting is needed for indexing
		echo "going to run samtools sort $SAM.filtered $SAM.sorted"
		samtools sort $SAM.filtered $SAM.sorted
	else
		echo "sam file $SAM.sorted already created"
	fi

	# created index for BAM file if needed
	if [ ! -e $SAM.sorted.bam.bai ]; then

		# this should result in faster processing
		echo "going to run samtools index $SAM.sorted.bam"
		samtools index $SAM.sorted.bam
	else
		echo "BAM file index $SAM.sorted.bam.bai already created"
	fi

done
# Switch back to old directory
cd ${old_wd}
