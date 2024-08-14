# Load necessary libraries
library(dplyr)
library(ggplot2)
library(factoextra)

# Define the output directory
output_folder <- './'

# Load the dataset
constructor_analysis <- read.csv('constructor_analysis_merged.csv')

# Select relevant features for K-Means clustering
kmeans_features <- constructor_analysis %>%
  select(points.x, wins, position) %>%
  na.omit()

# Standardize the features
kmeans_features_scaled <- scale(kmeans_features)

# Determine the optimal number of clusters using the Elbow Method
fviz_nbclust(kmeans_features_scaled, kmeans, method = "wss") +
  labs(title = "Elbow Method for Optimal Number of Clusters") +
  theme_minimal()

# Save the Elbow Method plot
ggsave(paste0(output_folder, 'kmeans_elbow_plot.png'))

# Perform K-Means Clustering with the optimal number of clusters (e.g., k = 4)
set.seed(123)
kmeans_result <- kmeans(kmeans_features_scaled, centers = 4, nstart = 25)

# Add the cluster assignments to the original data
constructor_analysis$cluster <- as.factor(kmeans_result$cluster)

# Visualize the clusters
fviz_cluster(kmeans_result, data = kmeans_features_scaled) +
  labs(title = "K-Means Clustering of Constructors") +
  theme_minimal()

# Save the clustering plot
ggsave(paste0(output_folder, 'kmeans_clustering_plot.png'))

# Output cluster centers and other details to a text file
sink(paste0(output_folder, 'kmeans_clustering_results.txt'))
cat("K-Means Clustering Results:\n")
print(kmeans_result)
sink()

