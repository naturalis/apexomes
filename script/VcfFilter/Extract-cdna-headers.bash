#!/bin/bash

list="$(cat Gorilla_gorilla.gorGor3.1.cdna.all.fa | egrep  ">.* en.*Gor3.1:16"  | awk -F ':' '{print $5"-"$6}' | sort -k1 -n)"

./FilterCdnaSNPsFromVcf.py "${list}" > codingfiltered.chr16.vcf