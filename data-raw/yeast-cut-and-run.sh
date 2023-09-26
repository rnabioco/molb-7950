
# data donwloaded from https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2236879
# grabbing the 16 second samples

# wget https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2236nnn/GSM2236871/suppl/GSM2236871%5FCut%2Dand%2DRun%5FAbf1%5F16s%2Ebed%2Egz
# wget https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2236nnn/GSM2236878/suppl/GSM2236878%5FCut%2Dand%2DRun%5FReb1%5F16s%2Ebed%2Egz

abf1_bed="GSM2236871_Cut-and-Run_Abf1_16s.bed.gz"
reb1_bed="GSM2236878_Cut-and-Run_Reb1_16s.bed.gz"

bedClip $abf1_bed sacCer3.chrom.sizes tmp
mv tmp $abf1_bed

bedClip $reb1_bed sacCer3.chrom.sizes tmp
mv tmp $reb1_bed

awk '($3 - $2 <= 121)' $abf1_bed > CutRun_Abf1_lt120.bed
awk '($3 - $2 > 150)' $abf1_bed > CutRun_Abf1_gt150.bed

awk '($3 - $2 <= 121)' $reb1_bed > CutRun_Reb1_lt120.bed
awk '($3 - $2 > 150)' $reb1_bed > CutRun_Reb1_gt150.bed

for bedfile in CutRun*.bed; do
    sample=$(basename $bedfile .bed)

    bedtools genomecov -i $bedfile -bg -g sacCer3.chrom.sizes > $sample.bg

    bedGraphToBigWig $sample.bg sacCer3.chrom.sizes $sample.bw
done

