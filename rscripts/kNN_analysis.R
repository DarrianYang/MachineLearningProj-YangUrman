# Load necessary libraries
library(class)
library(caret)
library(dplyr)

# Define the output directory
output_folder <- './'

# Load the dataset
race_results <- read.csv('race_results_merged.csv')

# Select numeric features and perform PCA
numeric_features <- race_results %>%
  select_if(is.numeric) %>%
  na.omit()

# Perform PCA
pca_result <- prcomp(numeric_features, center = TRUE, scale. = TRUE)
pca_data <- data.frame(pca_result$x)

# Select the first few principal components (PC1, PC2, PC3) as features
pca_features <- pca_data[, 1:3]

# Add the target variable (positionOrder) to the PCA features
pca_features$positionOrder <- race_results$positionOrder[complete.cases(numeric_features)]

# Normalize the positionOrder to categorize positions (e.g., top 5, 6-10, etc.)
pca_features$positionCategory <- cut(pca_features$positionOrder, breaks = c(0, 5, 10, 15, 20, max(pca_features$positionOrder)), 
                                     labels = c("Top 5", "6-10", "11-15", "16-20", "21+"))

# Split data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(pca_features$positionCategory, p = .7, list = FALSE)
trainData <- pca_features[trainIndex, ]
testData <- pca_features[-trainIndex, ]

# Train kNN model
knn_model <- knn(train = trainData[, 1:3], test = testData[, 1:3], cl = trainData$positionCategory, k = 5)

# Evaluate the model
confusion_mat <- confusionMatrix(knn_model, testData$positionCategory)

# Output results to a text file
sink(paste0(output_folder, 'knn_results.txt'))
cat("Confusion Matrix:\n")
print(confusion_mat)
sink()

# Plotting confusion matrix
confusion_mat_table <- as.data.frame(confusion_mat$table)
confusion_plot <- ggplot(confusion_mat_table, aes(x = Reference, y = Prediction)) +
  geom_tile(aes(fill = Freq), color = "white") +
  geom_text(aes(label = Freq), vjust = 1) +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Confusion Matrix for kNN Model", x = "Actual", y = "Predicted") +
  theme_minimal()

# Save the confusion matrix plot
ggsave(paste0(output_folder, 'knn_confusion_matrix.png'), plot = confusion_plot)
