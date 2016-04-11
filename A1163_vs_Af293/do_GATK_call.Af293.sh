#PBS -q js -l nodes=1:ppn=48,mem=96gb -N GATK -j oe -o GATK.log

module load java
module load gatk
module load picard
GENOME=genomes/A_fumigatus_Af293.fa

b=`basename $GENOME .fa`
dir=`dirname $GENOME`
ODIR=variant

mkdir -p $ODIR

CPU=1
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

if [ ! -f $dir/$b.dict ]; then
 java -jar $PICARD CreateSequenceDictionary \
 R=$GENOME OUTPUT=$dir/$b.dict
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=1;
fi

N=`ls clean_aln/*.bam | head -n $PBS_ARRAYID | tail -n 1`
O=`basename $N .bam`

if [ ! -f $ODIR/$O.g.vcf ]; then
java -Xmx96g -jar $GATK \
  -T HaplotypeCaller \
  -ERC GVCF \
  -variant_index_type LINEAR \
  -variant_index_parameter 128000 \
  -ploidy 1 \
  -I $N -R $GENOME \
  -o $ODIR/$O.g.vcf -nct $CPU
fi

