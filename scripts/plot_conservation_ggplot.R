library(ggplot2)
a1163all <- read.csv("A1163_vs_Af239.coding.classify.dat");
pdf("A1163_homolog_plot.pdf");

a1163<-subset(a1163all,a1163all$CHROM == "scf_000001_A_fumigatus_A1163" | 
a1163all$CHROM == "scf_000002_A_fumigatus_A1163" | 
a1163all$CHROM == "scf_000003_A_fumigatus_A1163" | 
a1163all$CHROM == "scf_000004_A_fumigatus_A1163" 
) 			

scores <- ggplot(a1163) + geom_point(aes(x=START,y=PERCENTID)) + 
       facet_wrap(~ CHROM,ncol=1,scales="free") + ggtitle("A1163 vs Af293 similarities") + xlab("Position in the genome") + ylab("Percent Identity") + theme_bw();

print(scores)

a1163<-subset(a1163all,a1163all$CHROM == "scf_000005_A_fumigatus_A1163" | 
a1163all$CHROM == "scf_000006_A_fumigatus_A1163" |
a1163all$CHROM == "scf_000007_A_fumigatus_A1163" | 
a1163all$CHROM == "scf_000008_A_fumigatus_A1163"
) 			


scores <- ggplot(a1163) + geom_point(aes(x=START,y=PERCENTID)) + 
       facet_wrap(~ CHROM,ncol=1,scales="free") + ggtitle("A1163 vs Af293 similarities") + xlab("Position in the genome") + ylab("Percent Identity") + theme_bw();

print(scores)
