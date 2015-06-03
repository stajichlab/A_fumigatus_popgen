#PBS -l nodes=1:ppn=1,walltime=4:00:00,mem=16gb -q js -N deDupRealign.Afum -j oe
module load java
module load picard
module load GATK/3.3.0
temp=/tmp
DIR=aln
ODIR=clean_aln

GENOME=genomes/A_fumigatus_A1163.fa
mkdir -p $ODIR
N=$PBS_ARRAYID
CPU=1
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

LISTFILE=raw/sra_strains.tab
if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "need to provide a number by PBS_ARRAYID or cmdline"
 exit
fi

LISTCT=`ls $DIR/*.SE.bam $DIR/*.PE.bam | wc -l`
if [ $N -gt $LISTCT ]; then
 echo "$N is too big, only $LISTCT bams in $DIR"
 exit
fi

FILE=`ls $DIR/*.SE.bam $DIR/*.PE.bam | head -n $N | tail -n 1`
prefix=`basename $FILE .bam`
echo "$FILE for $N - $prefix"


# dedup
if [ ! -e $DIR/$prefix.dedup.bam ]; then
java -Xmx16g -Djava.io.tmpdir=$temp -jar $PICARD/MarkDuplicates.jar \
 I=$FILE O=$DIR/$prefix.dedup.bam ASSUME_SORTED=true READ_NAME_REGEX=null \
 METRICS_FILE=$DIR/$prefix.dedup_metrics.txt \
 MAX_SEQUENCES_FOR_DISK_READ_ENDS_MAP=150000 CREATE_INDEX=true
fi

if [ ! -f $DIR/$prefix.dedup.bai ]; then
 java -jar $PICARD/BuildBamIndex.jar I=$DIR/$prefix.dedup.bam
fi

if [ ! -e $ODIR/$prefix.realign.bam ]; then
java -Xmx16g -Djava.io.tmpdir=$temp -jar $GATK \
       -T RealignerTargetCreator \
       -R $GENOME \
       -o $DIR/$prefix.gatk.intervals \
       -I $DIR/$prefix.dedup.bam

## Realign based on these intervals
java -Xmx16g -Djava.io.tmpdir=$temp -jar $GATK \
       -T IndelRealigner \
       -R $GENOME \
       -targetIntervals $DIR/$prefix.gatk.intervals \
       -I $DIR/$prefix.dedup.bam \
       -o $ODIR/$prefix.bam
fi
#realign
