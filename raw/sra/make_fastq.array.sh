#PBS -j oe -N makeFastq
module load sratoolkit
OUT=../fastq
LST=dir_list.txt

N=$PBS_ARRAYID
if [ ! $N ]; then 
 N=$1
fi

if [ ! $N ]; then
 echo "Need a PBS_ARRAYID or cmdline Num provided"
 exit
fi
dir=`head -n $N $LST | tail -n 1`

for file in `find $dir -name "*.sra"`
do
 base=`basename $file .sra`
 if [ ! -f $OUT/$base"_1.fastq.gz" ]; then
  echo "processing $dir/$base"
  fastq-dump -Q 33 --split-files --gzip -A $base -O $OUT $file 
 fi
done
