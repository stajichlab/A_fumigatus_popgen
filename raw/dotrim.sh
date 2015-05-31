#PBS -j oe -N sickle -l walltime=1:00:00
module load sickle

INPUT=fastq
OUTPUT=trim
LEN=50
QUAL=20
N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "need a num from PBS_ARRAYID or cmdline"
 exit
fi
FILE1=`ls $INPUT/*_1.fastq.gz | head -n $N | tail -n 1`
BASE=`basename $FILE1 _1.fastq.gz`

FILE2=$INPUT/$BASE"_2.fastq.gz"
OUTFILE1=$OUTPUT/$BASE.1.trim.fq
OUTFILE2=$OUTPUT/$BASE.2.trim.fq
OUTFILES=$OUTPUT/$BASE.s.trim.fq

echo "$FILE1 $FILE2 -- $OUTFILE1 $OUTFILE2 $OUTFILES"
if [ ! -f $OUTFILE1 ]; then
# only run if we haven't run this before
 if [ -f $FILE2 ]; then
  # paired end data
  sickle pe -f $FILE1 -r $FILE2 -t sanger -l $LEN -q $QUAL \
  -o $OUTFILE1 -p $OUTFILE2 -s $OUTFILES
 else
  sickle se -f $FILE1 -t sanger -l $LEN -q $QUAL -o $OUTFILE1
 fi

fi
