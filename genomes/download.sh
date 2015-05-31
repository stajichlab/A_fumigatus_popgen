curl  -O -C - http://www.aspergillusgenome.org/download/sequence/A_fumigatus_A1163/archive/A_fumigatus_A1163_2013_12_16_chromosomes.fasta.gz

# note this will need to point to the archive folder when a new version is released!
curl -O -C - http://www.aspergillusgenome.org/download/sequence/A_fumigatus_Af293/current/A_fumigatus_Af293_version_s03-m04-r34_chromosomes.fasta.gz

module load bwa/0.7.10
if [ ! -f A_fumigatus_A1163.bwt ]; then
 bwa index -p A_fumigatus_A1163 A_fumigatus_A1163_2013_12_16_chromosomes.fasta.gz
fi

if [ ! -f A_fumigatus_Af293.bwt ]; then
 bwa index -p A_fumigatus_Af293 A_fumigatus_Af293_version_s03-m04-r34_chromosomes.fasta.gz
fi
