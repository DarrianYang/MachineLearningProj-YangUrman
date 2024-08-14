# Load necessary libraries
library(dplyr)
library(caret)
library(ggplot2)
library(e1071)  # For Naive Bayes

# Define the output directory
output_folder <- './'

# Step 1: Load the dataset
constructor_analysis <- read.csv('constructor_analysis_merged.csv')

# Step 2: Perform K-Means Clustering
# Select relevant features for K-Means
kmeans_features <- constructor_analysis %>%
  select(points.x, wins, position) %>%
  na.omit()

# Perform K-Means Clustering
set.seed(123)
kmeans_result <- kmeans(kmeans_features, centers = 4)  # Assuming 4 clusters

# Add cluster labels to the original dataset
constructor_analysis$cluster <- kmeans_result$cluster

# Save the dataset with the cluster column
write.csv(constructor_analysis, 'constructor_analysis_with_clusters.csv', row.names = FALSE)

# Step 3: Visualize Cluster Centers
cluster_centers <- as.data.frame(kmeans_result$centers)
cluster_centers$cluster <- factor(1:nrow(cluster_centers))

# Melt the data for easier plotting
library(reshape2)
cluster_centers_melted <- melt(cluster_centers, id.vars = "cluster")

cluster_centers_plot <- ggplot(cluster_centers_melted, aes(x = variable, y = value, group = cluster, color = cluster)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  labs(title = "K-Means Cluster Centers", x = "Features", y = "Center Value") +
  theme_minimal()

# Save the cluster centers plot
ggsave(paste0(output_folder, 'kmeans_cluster_centers_plot.png'), plot = cluster_centers_plot)

# Step 4: Run Naive Bayes Analysis
# Load the dataset with clusters
constructor_analysis <- read.csv('constructor_analysis_with_clusters.csv')

# Select relevant features for Naive Bayes analysis
naive_bayes_features <- constructor_analysis %>%
  select(cluster, points.x, wins, position) %>%
  na.omit()

# Split data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(naive_bayes_features$cluster, p = .7, list = FALSE)
trainData <- naive_bayes_features[trainIndex, ]
testData <- naive_bayes_features[-trainIndex, ]

# Train Naive Bayes model
nb_model <- naiveBayes(cluster ~ ., data = trainData)

# Predict on test data
nb_predictions <- predict(nb_model, testData)

# Ensure both are factors with the same levels
nb_predictions <- factor(nb_predictions, levels = levels(factor(testData$cluster)))
testData$cluster <- factor(testData$cluster)

# Evaluate the model
confusion_mat_nb <- confusionMatrix(nb_predictions, testData$cluster)

# Output results to a text file
sink(paste0(output_folder, 'naive_bayes_results.txt'))
cat("Confusion Matrix for Naive Bayes:\n")
print(confusion_mat_nb)
sink()

# Plotting confusion matrix
confusion_mat_nb_table <- as.data.frame(confusion_mat_nb$table)
confusion_plot_nb <- ggplot(confusion_mat_nb_table, aes(x = Reference, y = Prediction)) +
  geom_tile(aes(fill = Freq), color = "white") +
  geom_text(aes(label = Freq), vjust = 1) +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Confusion Matrix for Naive Bayes Model", x = "Actual Cluster", y = "Predicted Cluster") +
  theme_minimal()

# Save the confusion matrix plot
ggsave(paste0(output_folder, 'naive_bayes_confusion_matrix.png'), plot = confusion_plot_nb)
