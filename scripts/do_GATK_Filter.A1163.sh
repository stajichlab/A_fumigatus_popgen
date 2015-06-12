#PBS -l nodes=1:ppn=1,mem=16gb -q js -N Afum.A1163.filt -j oe

module load GATK/3.4.0
module load java
INFILE=Afum.A1163.vcf
FILTERED=Afum.A1163.filtered.vcf
SELECTED=Afum.A1163.selected.vcf
GENOME=genomes/A_fumigatus_A1163.fa

if [ ! -f $FILTERED ]; then
java -Xmx3g -jar $GATK \
-T VariantFiltration -o $FILTERED \
--variant $INFILE -R $GENOME \
--clusterWindowSize 10  -filter "QD<8.0" -filterName QualByDepth \
-filter "MQ<=30.0" -filterName MapQual \
-filter "QUAL<100" -filterName QScore \
-filter "MQ0>=10 && ((MQ0 / (1.0 * DP)) > 0.1)" -filterName MapQualRatio \
-filter "FS>60.0" -filterName FisherStrandBias \
-filter "HaplotypeScore > 13.0" -filterName HaplotypeScore
fi

if [ ! -f $SELECTED ]; then
java -Xmx16g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $FILTERED \
   -o $SELECTED \
   --excludeFiltered

fi
