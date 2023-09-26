#! /usr/bin/env bash

# download and process cut&tag data from the CUT&TAG paper

wget https://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/hg19.chrom.sizes

wget https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3680nnn/GSM3680214/suppl/GSM3680214%5FK562%5FCTCF%5FRep1%2Ebed%2Egz
bedtools genomecov -i GSM3680214_K562_CTCF_Rep1.bed.gz -g hg19.chrom.sizes -bg
bedGraphToBigWig GSM3680214_K562_CTCF_Rep1.bg.gz hg19.chrom.sizes GSM3680214_K562_CTCF_Rep1.bw

wget https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3680nnn/GSM3680214/suppl/GSM3680214%5FK562%5FCTCF%5FRep2%2Ebed%2Egz
bedtools genomecov -i GSM3680214_K562_CTCF_Rep2.bed.gz -g hg19.chrom.sizes -bg  > GSM3680214_K562_CTCF_Rep2.bg
bedGraphToBigWig GSM3680214_K562_CTCF_Rep2.bg hg19.chrom.sizes GSM3680214_K562_CTCF_Rep2.bw
