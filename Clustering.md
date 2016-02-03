Clustering could be done with many combinations with datasets. For beginning with clustering you must determine what exactly you want
to cluster. For example: Do you want to use a reference? Do you want to have a coding reference or raw reference? 

Clustering with coding reference:
If you want to have a dataset with coding genes. You have to use the Extract-cdna-headers.bash script.
This script can be found in  apexomes/script/VcfFilter/Extract-cdna-headers.bash 
Please change the input directory variable "inputvcfdir" and change the output directory variable "outputdir"
to the right directories. Ga door naar Samenvoegen referentie.

Clustering with full reference:
Please check if the file extenstion contains ".bgz". This is a non existing extenstion that creates errors. If the extenstion
is present. Run the following two commands:

for file in *.bgz; do
    mv "$file" "`basename $file .bgz`.gz"
done

for file in *.bgz.tbi; do
    mv "$file" "`basename $file .bgz.tbi`.gz.tbi"
done

Run daarna bgzip -d *.gz per file om alles uit te pakken. Ga daarna naar Samenvoegen referentie.

Samenvoegen referentie:
Als alle vcf files er zijn. Run bcftools concat *.vcf > outputnaam.vcf
om één grote vcf file te maken
