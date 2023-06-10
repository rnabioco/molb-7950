import cyvcf2
import pdb

def high_impact(vnt):
  anns = vnt.INFO.get("ANN")
  if "HIGH" in anns or "MODERATE" in anns:
    return True
  return False

# find mutations that explain tub. it's genotype is encoded like [alt, alt, ref, ref].
# n.b. this is ordered with respect to the sample names in the VCF
tubs = [1, 1, 0, 0]

keep = []
for vnt in cyvcf2.VCF("combined.annotated.vcf.gz"):

    if vnt.CHROM == "chrXIII" and vnt.POS == 22157:
        pdb.set_trace()

    #if vnt.gt_types.tolist() == tubs and vnt.is_snp: # and high_quality(vnt) and high_impact(vnt): 
    #    pdb.set_trace()
    #    print(vnt)

