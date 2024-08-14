# Load necessary libraries
library(ggplot2)
library(HSAUR)
library(dplyr)

# Define the output directory
output_folder <- './'

# Load the dataset
race_results <- read.csv('race_results_merged.csv')

# Select numeric features for PCA (exclude non-numeric columns)
numeric_features <- race_results %>%
  select_if(is.numeric) %>%
  na.omit()

# Calculate the covariance matrix
cov_matrix <- cov(numeric_features)

# Calculate eigenvalues and eigenvectors
eig_values <- eigen(cov_matrix)$values
eig_vectors <- eigen(cov_matrix)$vectors

# Perform PCA
pca_result <- prcomp(numeric_features, center = TRUE, scale. = TRUE)
pca_summary <- summary(pca_result)

# Extract the first principal component
pc1 <- pca_result$rotation[,1]

# Correlation matrix for the dataset
correl_matrix <- round(cor(numeric_features), 2)

# Calculate eigenvalues and eigenvectors for the correlation matrix
eigcor <- eigen(correl_matrix)
eigcor_values <- eigcor$values
eigcor_vectors <- eigcor$vectors
perclambda <- ((eigcor_values)/sum(eigcor_values)) * 100

# Biplot of the first two principal components
biplot(pca_result, col = c("red", "green"))
ggsave(paste0(output_folder, 'pca_biplot.png'))

# Output results to a text file
sink(paste0(output_folder, 'pca_results.txt'))
cat("Covariance Matrix:
")
print(cov_matrix)
cat("
Eigenvalues:
")
print(eig_values)
cat("
Eigenvectors:
")
print(eig_vectors)
cat("
PCA Summary:
")
print(pca_summary)
cat("
First Principal Component (PC1):
")
print(pc1)
cat("
Correlation Matrix:
")
print(correl_matrix)
cat("
Eigenvalues of Correlation Matrix:
")
print(eigcor_values)
cat("
Eigenvectors of Correlation Matrix:
")
print(eigcor_vectors)
cat("
Percentage of Variance Explained by Each Eigenvalue:
")
print(perclambda)
sink()
