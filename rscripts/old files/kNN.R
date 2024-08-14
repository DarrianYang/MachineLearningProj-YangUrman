# Load necessary libraries
library(class)
library(caret)
library(ggplot2)

# Load the merged driver performance dataset
driver_performance <- read.csv("merged_driver_performance.csv")

# Select features and label for kNN
knn_data <- driver_performance %>% select(points, wins, position)
knn_labels <- driver_performance$position

# Convert to numeric and handle potential coercion to NA
knn_data <- as.data.frame(lapply(knn_data, function(x) as.numeric(as.character(x))))

# Replace NA values with the median of each column
knn_data <- knn_data %>% 
  mutate(across(everything(), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# Ensure there are no NA values left
if(any(is.na(knn_data))) {
  stop("There are still NA values present after replacement.")
}

# Split the data into training and testing sets (70% train, 30% test)
set.seed(123)
trainIndex <- createDataPartition(knn_labels, p = 0.7, list = FALSE)
knn_train <- knn_data[trainIndex, ]
knn_test <- knn_data[-trainIndex, ]
knn_train_labels <- knn_labels[trainIndex]
knn_test_labels <- knn_labels[-trainIndex]

# Train the kNN model with k = 3
k <- 11
knn_model <- knn(train = knn_train, test = knn_test, cl = knn_train_labels, k = k)

# Convert predictions and labels to factors with the same levels
knn_model <- factor(knn_model, levels = unique(c(knn_model, knn_test_labels)))
knn_test_labels <- factor(knn_test_labels, levels = unique(c(knn_model, knn_test_labels)))

# Save the kNN predictions to a text file
knn_predictions <- data.frame(Predicted = knn_model, Actual = knn_test_labels)
write.csv(knn_predictions, "knn_predictions_driver_performance_k3.csv", row.names = FALSE)

# Confusion matrix to evaluate the model
conf_matrix <- confusionMatrix(knn_model, knn_test_labels)
conf_matrix_summary <- capture.output(conf_matrix)
writeLines(conf_matrix_summary, "knn_confusion_matrix_driver_performance_k3.txt")

# Plot confusion matrix
confusionMatrixPlot <- as.data.frame(conf_matrix$table)
ggplot(confusionMatrixPlot, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile() + 
  ggtitle(paste("kNN Confusion Matrix (k =", k, ") - Driver Performance")) +
  scale_fill_gradient(low = "white", high = "red")

# Save the plot
ggsave("knn_confusion_matrix_plot_driver_performance_k3.png")

