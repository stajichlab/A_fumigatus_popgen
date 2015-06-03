#PBS -q js -l nodes=1:ppn=32,mem=96gb-q js -N GATK -j oe -o GATK.log

module load java
module load GATK/3.3.0
module load picard
GENOME=/shared/stajichlab/projects/A_fumigatus_popgen/genomes/A_fumigatus_A1163.fa

b=`basename $GENOME .fa`
dir=`dirname $GENOME`
ODIR=variant

mkdir -p $ODIR

CPU=1
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

if [ ! -f $dir/$b.dict ]; then
 java -jar $PICARD/CreateSequenceDictionary.jar \
 R=$GENOME OUTPUT=$dir/$b.dict
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=1;
fi

N=`ls clean_aln/*.bam | head -n $PBS_ARRAYID | tail -n 1`
O=`basename $N .bam`

if [ ! -f $ODIR/$O.GVCF ]; then
java -Xmx96g -jar $GATK \
  -T HaplotypeCaller \
  -ERC GVCF \
  -variant_index_type LINEAR \
  -variant_index_parameter 128000 \
  -ploidy 1 \
  -I $N -R $GENOME \
  -o $ODIR/$O.GVCF -nct $CPU
fi

