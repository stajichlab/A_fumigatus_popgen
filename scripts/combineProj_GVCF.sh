#PBS -l nodes=1:ppn=1,mem=16gb,walltime=168:00:00 -N GATK.GVCFCombine -o GATK.GVCFCombine.log -j oe

module load java
module load gatk/3.3-0
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
 VARFILES=`ls variant/$BASE*.GVCF |  perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`
 V="$V $VARFILES"
done

echo $V
mkdir -p project_varfiles
java -Xmx16g -jar $GATK \
    -T CombineGVCFs \
    -R $GENOME \
    $V \
    -o project_varfiles/$PROJECT.GVCF 
