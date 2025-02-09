#Cataloguestats
library(tidyverse)
library(RColorBrewer)
library(ggrepel)
library(scales)

# Load the data
CatStats<- read_delim("../ORFCatalogueStats.txt", delim = "\t", col_names = T)
#Tidy data by Kingdom pivot longer by columns to new column called Kingdom
CatStatsTidy<- CatStats %>% pivot_longer(cols = c(2:7), names_to = "Kingdom", values_to = "Count")
#Rename first column of the table to ORFData
colnames(CatStatsTidy)[1]<- "ORFData"
#Remove the rows with total in the Kingdom column
CatStatsTidy<- CatStatsTidy %>% filter(Kingdom != "Total")

#Pie chart plot of ORFData's ORFs values by Kingdom avoiding overlap of text
CatStatsTidy %>%
  filter(ORFData == "Total ORFs") %>%
  ggplot(aes(x = "", y = Count, fill = Kingdom)) +  
  geom_bar(width = 1, stat = "identity") +  
  coord_polar("y", start = 0) +  
  scale_fill_brewer(palette = "Set1") +  
  geom_text_repel(aes(label = paste0(round(Count/sum(Count)*100, digits = 2), "%")), 
                  position = position_stack(vjust = 0.5)) +  
  theme_void() +  
  theme(legend.position = "right") +  
  labs(title = "ORFs by Taxonomic Assignment") +  
  guides(fill = guide_legend(title = NULL))+
  scale_fill_brewer(palette = "Set1", 
                    labels = function(x) paste0(x, " ", 
                                                CatStatsTidy %>%
                                                  filter(ORFData == "Total ORFs") %>%
                                                  group_by(Kingdom) %>%
                                                  summarize(Count = sum(Count)) %>%
                                                  filter(Kingdom %in% x) %>%
                                                  pull(Count), 
                                                " ORFs"))



#Transform CatStatsTidy to percentages. 
CatStatsTidyPerc<- CatStatsTidy %>% filter(ORFData == "Total ORFs") 
#Divide CatsStatsTidy/s each row by kingdom, by CatStatsTidyPerc by kingdom 
CatStatsTidyPerc<- CatStatsTidyPerc %>% select(Kingdom, Count) %>% rename(Total = Count)
CatStatsTidyPerc<- CatStatsTidyPerc %>% mutate(Percentage = 100)
CatStatsTidyPerc<- CatStatsTidyPerc %>% mutate(ORFData = "Total ORFs")
CatStatsTidyPerc<- CatStatsTidyPerc %>% select(ORFData, Kingdom, Total, Percentage)
CatStatsTidyPerc<- CatStatsTidyPerc %>% bind_rows(CatStatsTidy %>% filter(ORFData != "Total ORFs") %>% left_join(CatStatsTidyPerc, by = "Kingdom") %>% mutate(Percentage = round(Count/Total*100, digits = 2)))

CatStatsTidyPerc <- CatStatsTidyPerc[-c(1:5),-c(1, 3,6,7)]
#Barplot of Mapped to each Database
CatStatsTidyPerc %>% ggplot(aes(x = Kingdom, y = Percentage, fill = ORFData.x)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(Percentage, "%")), position = position_dodge(width = 0.9), size = 5, hjust = 0.75) +
  theme_minimal() +
  scale_fill_brewer(palette = "Dark2") +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(title = NULL))+
  labs(x = "Kingdom", y = "Percentage ORFs") +
  coord_flip()
