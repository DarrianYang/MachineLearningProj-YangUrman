# Load necessary libraries
library(dplyr)
library(caret)

# Load the dataset
driver_performance <- read.csv("driver_performance_merged.csv")

# Create a Binary Target Variable for Logistic Regression
# We'll use 'position' as a proxy for 'driver_standings'
driver_performance <- driver_performance %>%
  mutate(high_standing = as.factor(ifelse(position <= median(position, na.rm = TRUE), 1, 0)))

# Ensure that there are enough data points for both levels of high_standing
if (sum(driver_performance$high_standing == 1) > 1 && sum(driver_performance$high_standing == 0) > 1) {
  
  # Split the data into training and testing sets
  set.seed(123)
  trainIndex_driver <- createDataPartition(driver_performance$high_standing, p = .8, list = FALSE)
  train_x_driver <- driver_performance[trainIndex_driver, -which(names(driver_performance) %in% c("position", "high_standing"))]
  train_y_driver <- driver_performance[trainIndex_driver, "high_standing"]
  test_x_driver <- driver_performance[-trainIndex_driver, -which(names(driver_performance) %in% c("position", "high_standing"))]
  test_y_driver <- driver_performance[-trainIndex_driver, "high_standing"]
  
  # 1. Logistic Regression
  model_logit <- glm(high_standing ~ ., data = data.frame(train_x_driver, high_standing = train_y_driver), family = binomial)
  predictions_logit <- predict(model_logit, test_x_driver, type = "response")
  logit_results <- ifelse(predictions_logit > 0.5, 1, 0)
  logit_conf_matrix <- confusionMatrix(factor(logit_results), factor(test_y_driver))
  write.table(logit_conf_matrix$table, file = "logit_driver_performance_results.txt", sep = "\t")
  
  # 2. SVM on Driver Performance
  model_svm <- svm(high_standing ~ ., data = data.frame(train_x_driver, high_standing = train_y_driver))
  predictions_svm <- predict(model_svm, test_x_driver)
  svm_conf_matrix <- confusionMatrix(factor(predictions_svm), factor(test_y_driver))
  write.table(svm_conf_matrix$table, file = "svm_driver_performance_results.txt", sep = "\t")
  
  # 3. Naive Bayes on Driver Performance
  model_nb <- naiveBayes(high_standing ~ ., data = data.frame(train_x_driver, high_standing = train_y_driver))
  predictions_nb <- predict(model_nb, test_x_driver)
  nb_results <- confusionMatrix(predictions_nb, factor(test_y_driver))
  write.table(nb_results$table, file = "nb_driver_performance_results.txt", sep = "\t")
  
  # Save all models and results to a file
  save(model_logit, model_svm, model_nb, file = "f1_driver_performance_models_and_results.RData")
} else {
  print("Not enough data points for binary classification in high_standing. Adjust your dataset or classification criteria.")
}

