
#### plotting eDNA data

#set working directory
setwd("/Users/sophiegresham/Dropbox/PhD/Indonesia Workshop/Workshop Presentations:Practicals/eDNA/Data")

library(reshape2)
library(dplyr)
library(lattice)
library(ggplot2)
library(viridis)

#read in our raw eDNA data
eDNA_data <- read.csv("SILVA_138_eDNA.csv")

#how does it look? are all the columns separated and look correct?
#use the head() function to inspect the data, and click on the dataframe in the environment to see it in a new tab
head(eDNA_data)

#have a look at the data and the columns - its good to understand your data before you begin

#lets add in the sampling locations into the data
#you could also do this by combining the data with a metadata table
eDNA_data$counts[eDNA_data$counts == 'barcode04'] <- 'Lake Matano'
eDNA_data$counts[eDNA_data$counts == 'barcode05'] <- 'Lake Poso'
eDNA_data$counts[eDNA_data$counts == 'barcode06'] <- 'Lake Towuti'


########## occurence heatmap

#lets plot the occurrence count for each sampling location
#we will look at the occurrence at the phyla, famalies and species level

#phylum
df_cross_phylum <- dcast(eDNA_data, counts ~ phylum, length)
rownames(df_cross_phylum) <- c("Lake Matano", "Lake Mahalona", "Lake Towuti", "Unclassified")
df_cross_phylum <- subset(df_cross_phylum, select = -counts)
df_cross_phylum <- subset(df_cross_phylum, select = -Var.2)

df_cross_phylum_table = as.matrix(df_cross_phylum)

par(mar = c(1,1,1,1))
# Create the heatmap with levelplot
levelplot(df_cross_phylum_table, col.regions = colorRampPalette(c("lemonchiffon", "indianred3"))(17),
          scales = list(x = list(rot = 45)), 
          xlab = "Sample Site", ylab = "Phylum",
          main = "",
          panel = function(x, y, ...) {
            panel.levelplot(x, y, ...)
            panel.text(x = x, y = y, labels = df_cross_phylum_table, cex = 0.6, col = "black", font = 2)
          })


#family
df_cross_family <- dcast(eDNA_data, counts ~ family, length)
rownames(df_cross_family) <- c("Lake Matano", "Lake Mahalona", "Lake Towuti", "Unclassified")
df_cross_family <- subset(df_cross_family, select = -counts)
df_cross_family <- subset(df_cross_family, select = -Var.2)

df_cross_family_table = as.matrix(df_cross_family)

par(mar = c(1,1,1,1))
# Create the heatmap with levelplot
levelplot(df_cross_family_table, col.regions = colorRampPalette(c("lemonchiffon", "indianred3"))(17),
          scales = list(x = list(rot = 45)), 
          xlab = "Sample Site", ylab = "Family",
          main = "",
          panel = function(x, y, ...) {
            panel.levelplot(x, y, ...)
            panel.text(x = x, y = y, labels = df_cross_family_table, cex = 0.6, col = "black", font = 2)
          })


#genus and species
df_cross_species <- dcast(eDNA_data, counts ~ scientific_name, length)
rownames(df_cross_species) <- c("Lake Matano", "Lake Mahalona", "Lake Towuti", "Unclassified")
df_cross_species <- subset(df_cross_species, select = -counts)
df_cross_species <- subset(df_cross_species, select = -Var.2)

df_cross_species_table = as.matrix(df_cross_species)

par(mar = c(1,1,1,1))
# Create the heatmap with levelplot
levelplot(df_cross_species_table, col.regions = colorRampPalette(c("lemonchiffon", "indianred3"))(17),
          scales = list(x = list(rot = 45)), 
          xlab = "Sample Site", ylab = "Phylum",
          main = "Species count ",
          panel = function(x, y, ...) {
            panel.levelplot(x, y, ...)
            panel.text(x = x, y = y, labels = df_cross_species_table, cex = 0.6, col = "black", font = 2)
          })





########## relative abundance stacked barplot

#we can also compare the species counts within each location
#to do this we will plot the counts as a stacked barplot

eDNA_data$count <- 1
eDNA_data$id <- 1:length(eDNA_data$scientific_name)

class_colors <- c("red", "steelblue4", "palegreen1", "orange", "purple", 
                  "yellow", "cyan", "magenta", "brown", "thistle", 
                  "slategray3", "darkgreen", "skyblue", "white", "black")

#phylum

#remove NA values from target column 
eDNA_data_2 <- eDNA_data[!is.na(eDNA_data$phylum) & eDNA_data$phylum != "", , drop = FALSE]

eDNA_data_table <- eDNA_data_2 %>%
  group_by(phylum, counts) %>%
  summarize(RelAbundance = sum(id) / sum(eDNA_data_2$id) * 100)

ggplot(eDNA_data_table, aes(x = counts, y = RelAbundance, fill = phylum)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(title = "Relative abundance of phyla",
       x = "SampleID",
       y = "Relative abundance (%)",
       fill = "Phylum") +
  scale_fill_manual(values = class_colors) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#family

#remove NA values from target column 
eDNA_data_2 <- eDNA_data[!is.na(eDNA_data$family) & eDNA_data$family != "", , drop = FALSE]

eDNA_data_table <- eDNA_data_2 %>%
  group_by(family, counts) %>%
  summarize(RelAbundance = sum(id) / sum(eDNA_data_2$id) * 100)

ggplot(eDNA_data_table, aes(x = counts, y = RelAbundance, fill = family)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(title = "Relative abundance of families",
       x = "SampleID",
       y = "Relative abundance (%)",
       fill = "Family") +
  scale_fill_manual(values = class_colors) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#genus and species

#remove NA values from target column 
eDNA_data_2 <- eDNA_data[!is.na(eDNA_data$scientific_name) & eDNA_data$scientific_name != "", , drop = FALSE]

eDNA_data_table <- eDNA_data_2 %>%
  group_by(scientific_name, counts) %>%
  summarize(RelAbundance = sum(id) / sum(eDNA_data_2$id) * 100)

ggplot(eDNA_data_table, aes(x = counts, y = RelAbundance, fill = scientific_name)) +
  geom_bar(stat = "identity", position = "fill") +
  labs(title = "Relative abundance of species",
       x = "SampleID",
       y = "Relative abundance (%)",
       fill = "Species") +
  scale_fill_manual(values = class_colors) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))






