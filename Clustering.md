Clustering could be done with many combinations with datasets. For beginning with clustering you must determine what exactly you want
to cluster. For example: Do you want to use a reference? Do you want to have a coding reference or raw reference? 

# Clustering with coding reference:
If you want to have a dataset with coding genes. You have to use the Extract-cdna-headers.bash script.
This script can be found in  http://www.github.com/naturalis/apexomes/script/VcfFilter/Extract-cdna-headers.bash
Please change the input directory variable "inputvcfdir" and change the output directory variable "outputdir"
to the right directories. Go to concat reference for further instructions.

# Clustering with full reference:
Please check if the file extenstion contains ".bgz". This is a non existing extenstion that creates errors. If the extenstion
is present. Run the following two commands:

`for file in *.bgz; do
    mv "$file" "``basename $file .bgz``.gz"
done`

for file in *.bgz.tbi; do
    mv "$file" "``basename $file .bgz.tbi``.gz.tbi"
done

After that, run `bgzip -d *.gz` for each file to extract everything one by one. After that, go to concat reference.
Run daarna bgzip -d *.gz per file om alles uit te pakken. Ga daarna naar Samenvoegen referentie.

# Concat reference:
If all vcf file are represent. Run `bcftools concat *.vcf > outputname`.
This is to create a bulky file for all vcf data.

# Merge reference with your data:
This step is repettive. First you have to compress the two vcf files you want to merge: For example reference.vcf and Auzoux.vcf
First you have to run:
`bgzip reference.vcf`
`tabix -p vcf reference.vcf.gz`
`bgzip Auzoux.vcf`
`tabix -p vcf Auzoux.vcf.gz`
This is to compress the files and create indexes so they can be used for merging. The merging can be done by
bcftools merge reference.vcf.gz Auzoux.vcf.gz > AuzouxMergedWithRef.vcf
This will create a large file for the Auzoux Gorilla and the reference. If you want to add more gorillas, then you have
to run de bgzip for the new large reference file and your next Gorilla. If you have added all the gorillas you want, go to Clustering.

# Clustering:
To do clustering you have to convert the vcf file to the plink format file. This can be done by:
`vcftools --vcf INPUTFILE.vcf --plink --out  OUTPUTFILE.raw`
Now you have to run two plink commands:
`plink --file OUTPUTFILE.raw --genome --noweb --allow-no-sex --out OUTPUTFILE.raw`
`plink --file OUTPUTFILE.raw --read-genome OUTPUTFILE.raw.genome --cluster --mds-plot 2 --noweb`


After that you can load the result file into R and visualize it.
Example code:
`getwd()
d <- read.table("plink.mds", h=T)
print("Auzoux can have different locations")
d$pop = factor(c(rep("GBB", 7), rep("GBG", 9), rep("GGD", 1), rep("GGG", 27), rep("Sandra"), "Thirza", "Auzoux"))
d$pop
refnames <- c( "GBB - Eastern Gorilla", "GBG - Eastern Gorilla", "GGD - Western Gorilla", "GGG - Western Gorilla")
plot(d$C1, d$C2, col=as.integer(d$pop), pch=19, xlab="Dimension 1", ylab="Dimension 2", main = "MDS analysis on chromosome 1 reference, Sandra, Thirza and Auzoux ")
legend("topleft", c("Auzoux", refnames, "Sandra", "Thirza"), pch=19, col=c(1,2,3,4, 5, 6, 7))
text(d$C1, d$C2, labels=c(rep(NA, 22), "Sandra", "Naam hier"), pos=2)
text(d$C1, d$C2, labels=c(rep(NA, 44), "Sandra", NA), pos=2)
text(d$C1, d$C2, labels=c(rep(NA, 45), "Thirza", NA), pos=1)
text(d$C1, d$C2, labels=c(rep(NA, 46), "Auzoux", NA), pos=1)`
