# Load necessary libraries
library(rpart)
library(rpart.plot)

# Load the merged driver performance dataset
driver_performance <- read.csv("merged_driver_performance.csv")

# Select features and label for Decision Tree
dt_data <- driver_performance %>% select(points, wins)
dt_labels <- as.factor(driver_performance$position)  # Ensure labels are factors

# Replace NA values with the median of each column
dt_data <- dt_data %>% mutate(across(everything(), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# Combine the data and labels for model training
dt_dataset <- cbind(dt_data, position = dt_labels)

# Split the data into training and testing sets (70% train, 30% test)
set.seed(123)
trainIndex <- createDataPartition(dt_labels, p = 0.7, list = FALSE)
dt_train <- dt_dataset[trainIndex, ]
dt_test <- dt_dataset[-trainIndex, ]

# Build the Decision Tree model with modified control parameters
dt_control <- rpart.control(cp = 0.05, minsplit = 30, maxdepth = 4, xval = 10)
dt_model <- rpart(position ~ points + wins, data = dt_train, method = "class", control = dt_control)

# Prune the tree based on the optimal cp
optimal_cp <- dt_model$cptable[which.min(dt_model$cptable[,"xerror"]),"CP"]
pruned_dt_model <- prune(dt_model, cp = optimal_cp)

# Plot the pruned Decision Tree with increased dimensions and improved labeling
png("improved_decision_tree_plot.png", width = 1200, height = 1200, res = 150)
rpart.plot(pruned_dt_model, extra = 106, cex = 0.7, box.palette = "RdYlGn", shadow.col = "gray", nn = TRUE)
dev.off()

# Make predictions on the test set
dt_predictions <- predict(pruned_dt_model, dt_test, type = "class")

# Evaluate the model
conf_matrix <- confusionMatrix(dt_predictions, dt_test$position)
conf_matrix_summary <- capture.output(conf_matrix)
writeLines(conf_matrix_summary, "pruned_decision_tree_confusion_matrix.txt")
