for file in `find . -name '*.sra'`; do x=`basename $file .sra`;  echo $x;  n=`ls ../fastq/$x*`; echo $n; done
