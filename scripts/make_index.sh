module load picard
module load java
module load bwa/0.7.10
module load samtools
zcat genomes/A_fumigatus_A1163_2013_12_16_chromosomes.fasta.gz > genomes/A_fumigatus_A1163.fa
zcat genomes/A_fumigatus_Af293_version_s03-m04-r34_chromosomes.fasta.gz > genomes/A_fumigatus_Af293.fa

rm -f genomes/A_fumigatus_A1163.dict
rm -f genomes/A_fumigatus_Af293.dict
java -jar $PICARD/CreateSequenceDictionary.jar R=genomes/A_fumigatus_A1163.fa  OUTPUT=genomes/A_fumigatus_A1163.dict
java -jar $PICARD/CreateSequenceDictionary.jar R=genomes/A_fumigatus_Af293.fa  OUTPUT=genomes/A_fumigatus_Af293.dict
samtools faidx genomes/A_fumigatus_A1163.fa
samtools faidx genomes/A_fumigatus_Af293.fa

if [ ! -f genomes/A_fumigatus_A1163.bwt ]; then
 bwa index -p genomes/A_fumigatus_A1163 genomes/A_fumigatus_A1163_2013_12_16_chromosomes.fasta.gz
fi

if [ ! -f genomes/A_fumigatus_Af293.bwt ]; then
 bwa index -p genomes/A_fumigatus_Af293 genomes/A_fumigatus_Af293_version_s03-m04-r34_chromosomes.fasta.gz
fi
