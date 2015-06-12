#PBS -j oe -N makeFastq
module load sratoolkit
OUT=../fastq
for dir in DRP002354 ERP009642 ERP001097 SRP008192 SRP006193 DRP001352
do
for file in `find $dir -name "*.sra"`
do
 base=`basename $file .sra`
 if [ ! -f $OUT/$base"_1.fastq.gz" ]; then
  echo "processing $base"
  fastq-dump -Q 33 --split-files --gzip -A $base -O $OUT $file 
 fi
done
done
