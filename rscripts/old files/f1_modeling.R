# Load necessary libraries
library(dplyr)
library(caret)
library(e1071)
library(rpart)
library(ggplot2)
library(class)

# Load the datasets
race_results <- read.csv("race_results_merged.csv")
driver_performance <- read.csv("driver_performance_merged.csv")

# 1. Handling Missing Values in Race Results
race_results <- race_results %>% drop_na()  # Remove rows with any missing values

# Ensure all features used in kNN are numeric
numeric_features <- race_results %>% select_if(is.numeric)

# 2. k-Nearest Neighbors (kNN) on Race Results
set.seed(123)
trainIndex <- createDataPartition(numeric_features$points, p = .8, list = FALSE)
train_x <- numeric_features[trainIndex, -which(names(numeric_features) %in% c("points", "win"))]
train_y <- numeric_features[trainIndex, "points"]
test_x <- numeric_features[-trainIndex, -which(names(numeric_features) %in% c("points", "win"))]
test_y <- numeric_features[-trainIndex, "points"]

k <- 5  # Number of neighbors
predictions_knn <- knn(train_x, test_x, train_y, k = k)
knn_results <- confusionMatrix(predictions_knn, factor(test_y))
write.table(knn_results$table, file = "knn_race_results.txt", sep = "\t")

# 3. Decision Trees on Race Results
# Convert all categorical variables into numeric ones (using one-hot encoding)
factor_columns <- sapply(race_results, is.factor)
if (any(factor_columns)) {
  race_results <- race_results %>% 
    mutate(across(where(is.factor), as.numeric))
}

set.seed(123)
trainIndex <- createDataPartition(race_results$points, p = .8, list = FALSE)
train_x <- race_results[trainIndex, -which(names(race_results) %in% c("points", "win"))]
train_y <- race_results[trainIndex, "points"]
test_x <- race_results[-trainIndex, -which(names(race_results) %in% c("points", "win"))]
test_y <- race_results[-trainIndex, "points"]

model_tree <- rpart(points ~ ., data = data.frame(train_x, points = train_y), method = "anova")
predictions_tree <- predict(model_tree, test_x)
mse_tree <- mean((predictions_tree - test_y)^2)
write.table(mse_tree, file = "tree_race_results_mse.txt", sep = "\t")
