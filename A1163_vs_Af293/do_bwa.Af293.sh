#PBS -l nodes=1:ppn=8 -q js -N bwa.Afum -j oe -l walltime=8:00:00
module load bwa/0.7.12
module load java
module load picard
GENOME=genomes/A_fumigatus_Af293.fa
GENOMESTRAIN=Af293
INDIR=trim
ODIR=aln

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

if [ $N -eq "1" ]; then 
 echo "Skipping 1 as it is the header in the infile"
 exit
fi
MAX=`wc -l $LISTFILE | awk '{print $1}'`

if [ $N -gt $MAX ]; then 
 echo "$N is too big, only $MAX lines in $LISTFILE"
 exit
fi
# do pairwise
LINE=`head -n $N $LISTFILE | tail -n 1`
RUN=`echo "$LINE" | awk '{print $2}'`
STRAIN=`echo $LINE | awk '{print $4}'` 
echo "RUN is $RUN, STRAIN is $STRAIN"
if [ -f $INDIR/$RUN.1.trim.fq.gz ]; then
 echo "bwa mem -t $CPU $GENOME $INDIR/$RUN.1.trim.fq.gz $INDIR/$RUN.2.trim.fq.gz > $ODIR/$RUN.$GENOMESTRAIN.PE.sam"
 bwa mem -t $CPU $GENOME $INDIR/$RUN.1.trim.fq.gz $INDIR/$RUN.2.trim.fq.gz > $ODIR/$RUN.$GENOMESTRAIN.PE.sam
fi

if [ -f $INDIR/$RUN.s.trim.fq.gz ]; then
 echo "bwa mem -t $CPU $GENOME $INDIR/$RUN.s.trim.fq.gz > $ODIR/$RUN.$GENOMESTRAIN.SE.sam"
 if [ ! -f $ODIR/$RUN.$GENOMESTRAIN.SE.sam ]; then
  bwa mem -t $CPU $GENOME $INDIR/$RUN.s.trim.fq.gz > $ODIR/$RUN.$GENOMESTRAIN.SE.sam
 fi
fi


if [ ! -f $ODIR/$RUN.$GENOMESTRAIN.PE.bam ]; then
 java -jar $PICARD AddOrReplaceReadGroups I=$ODIR/$RUN.$GENOMESTRAIN.PE.sam O=$ODIR/$RUN.$GENOMESTRAIN.PE.bam \
 RGID=$STRAIN RGSM=$RUN RGPL=illumina RGLB=$RUN RGPU=$RUN SO=coordinate
fi


if [ ! -f $ODIR/$RUN.$GENOMESTRAIN.SE.bam ]; then
 java -jar $PICARD AddOrReplaceReadGroups I=$ODIR/$RUN.$GENOMESTRAIN.SE.sam O=$ODIR/$RUN.$GENOMESTRAIN.SE.bam \
 RGID=$STRAIN RGSM=$RUN RGPL=illumina RGLB=$RUN RGPU=$RUN SO=coordinate
fi


