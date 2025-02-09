
#Load Libraries
library(tidyverse)
library(vegan)
library(ggplot2)
library(ggrepel)
library(RColorBrewer)


#Contig cluster with SimKa
SimkaAbund<-read.csv("mat_abundance_braycurtis.csv.gz", sep = ";", row.names = 1)

#Hierarchical clustering
SimkaAbund2<-dist(SimkaAbund, method = "maximum")
hcSAb<-hclust(SimkaAbund2, method = "complete")
plot(hcSAb)

#NMDS
SAbNMDS<-metaMDS(SimkaAbund, distance = "bray", k = 3) #No convergence
plot(SAbNMDS)

#Plot with ggplot2

SAbNMDSscores<-as.data.frame(scores(SAbNMDS))
SAbNMDSscores$Station<-rownames(SimkaAbund)
rownames(SAbNMDSscores)<-gsub("_S_", "_", rownames(SAbNMDSscores))
rownames(SAbNMDSscores)<-gsub("_Wi", "_Wi20", rownames(SAbNMDSscores))


ggplot(data=SAbNMDSscores)+
  geom_point(data=SAbNMDSscores,aes(x=NMDS1,y=NMDS2),size=2)+ 
  geom_text_repel(data=SAbNMDSscores,aes(x=NMDS1,y=NMDS2, label=Station),  max.overlaps = getOption("ggrepel.max.overlaps", default = 33),
                  size=4,vjust=0,hjust=0)

