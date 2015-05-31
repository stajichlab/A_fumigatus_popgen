#PBS -l nodes=1:ppn=1,mem=2gb,walltime=2:00:00 -N aspergillusSRA -j oe 
module load aspera
ascp -i /opt/aspera/3.3.3/etc/asperaweb_id_dsa.openssh -k2 -T -l200m anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByStudy/sra/SRP/SRP006/SRP006193/ ./
