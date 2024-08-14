# Load necessary libraries
library(ggplot2)
library(ggfortify)
library(dplyr)

# Define the output directory
output_folder <- './'

# Load the dataset
race_results <- read.csv('race_results_merged.csv')

# Select numeric features for PCA (exclude non-numeric columns)
numeric_features <- race_results %>%
  select_if(is.numeric) %>%
  na.omit()

# Perform PCA
pca_result <- prcomp(numeric_features, center = TRUE, scale. = TRUE)

# Create a biplot with similar style to the provided image
biplot <- autoplot(pca_result, data = numeric_features, loadings = TRUE, loadings.label = TRUE, loadings.colour = "blue",
                   loadings.label.colour = "blue", loadings.label.size = 3, loadings.arrow.size = 0.5, loadings.arrow.color = "red") +
  labs(title = "Principal Component Analysis (PCA)", x = "PC1", y = "PC2") +
  theme_minimal() +
  theme(axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.title = element_text(hjust = 0.5, size = 16))

# Save the biplot
ggsave(paste0(output_folder, 'pca_custom_biplot.png'), plot = biplot)

