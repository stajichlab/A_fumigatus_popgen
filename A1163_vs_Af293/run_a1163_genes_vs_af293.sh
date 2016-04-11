#PBS -l nodes=1:ppn=8,mem=4gb -j oe -l walltime=18:00:00

module load fasta

CPU=$PBS_NUM_PPN
if [ ! $CPU ]; then
 CPU=2
fi

fasta36 -T $CPU -m 8c -E 1e-20 genomes/A_fumigatus_A1163_orf_coding.fasta genomes/A_fumigatus_Af293_current_orf_coding.fasta > A1163_vs_Af239.FASTA


