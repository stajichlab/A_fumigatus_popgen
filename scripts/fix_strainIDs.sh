LISTFILE=raw/sra_strains.tab

#LINE=`head -n $N $LISTFILE | tail -n 1`
#RUN=`echo "$LINE" | awk '{print $2}'`
#STRAIN=`echo $LINE | awk '{print $4}'` 
if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=$1
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=1
fi

file=`ls variant/*.GVCF | head -n $PBS_ARRAYID | tail -n 1`
 b=`basename $file .GVCF`
 sra=`echo $b | awk -F. '{print $1}'`
 strain=`grep $sra $LISTFILE | head -n 1 | awk '{print $4}'`
if [ ! -f varfix/$b.GVCF ]; then
 echo "file is $file. $strain $sra"
 perl -p -e "if( /^#CHROM/ ) { s/$sra/$strain/ }" $file > varfix/$b.GVCF
fi
