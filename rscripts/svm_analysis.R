# Load necessary libraries
library(e1071)
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

# Split data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(pca_features$positionOrder, p = .7, list = FALSE)
trainData <- pca_features[trainIndex, ]
testData <- pca_features[-trainIndex, ]

# Train SVM model (as regression)
svm_model <- svm(positionOrder ~ ., data = trainData, kernel = "linear")

# Predict using the SVM model
svm_predictions <- predict(svm_model, testData)

# Evaluate the model
svm_performance <- postResample(pred = svm_predictions, obs = testData$positionOrder)

# Output results to a text file
sink(paste0(output_folder, 'svm_results_direct_prediction.txt'))
cat("SVM Performance Metrics:\n")
print(svm_performance)
sink()

# Plotting the results (actual vs. predicted)
results_plot <- ggplot(testData, aes(x = positionOrder, y = svm_predictions)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Actual vs Predicted Positions", x = "Actual Position", y = "Predicted Position") +
  theme_minimal()

# Save the plot
ggsave(paste0(output_folder, 'svm_results_plot.png'), plot = results_plot)

