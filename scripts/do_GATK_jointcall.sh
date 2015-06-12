#PBS -q js -l nodes=1:ppn=24,mem=512gb -N GATK.GVCFGeno 

module load java
module load GATK/3.3.0
module load picard

GENOME=genomes/A_fumigatus_A1163.fa
CPU=1
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

b=`basename $GENOME .fa`
dir=`dirname $GENOME`
N=`ls project_varfiles/*.GVCF | perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`

#N=`ls variant/*.GVCF | perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`
#echo $N

java -Xmx512g -jar $GATK \
    -T GenotypeGVCFs \
    -R $GENOME \
    $N \
    -o Afum.vcf \
    -nt $CPU 
