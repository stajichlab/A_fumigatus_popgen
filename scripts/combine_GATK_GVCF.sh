#PBS -l nodes=1:ppn=2,mem=4gb,walltime=168:00:00 -N GATK.GVCFCombine

module load java
module load GATK/3.3.0
#module load picard

GENOME=genomes/A_fumigatus_A1163.fa
CPU=1
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

N=$PBS_ARRAYID

if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then 
 N=1
fi

b=`basename $GENOME .fa`
dir=`dirname $GENOME`

PROJECT=`head -n $N raw/projects.tab | tail -n 1`
echo "project is $PROJECT"
SRA=`grep $PROJECT raw/sra_strains.tab | awk '{print $2}' | sort | uniq`
V=""
for BASE in $SRA
do
 echo $BASE
 VARFILES=`ls variant/$BASE*.GVCF |  perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`
 echo $VARFILES
 V="$V $VARFILES"
done

echo $V

java -Xmx4g -jar $GATK \
    -T CombineGVCFs \
    -R $GENOME \
    $V \
    -o project_varfiles/$PROJECT.GVCF \
    -nt $CPU
