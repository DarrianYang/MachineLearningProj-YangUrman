# Load necessary libraries
library(dplyr)
library(caret)
library(ggplot2)

# Define the output directory
output_folder <- './'

# Load the dataset
constructor_analysis <- read.csv('constructor_analysis_merged.csv')

# Select relevant features for the linear regression model
# We will use 'position' as the target variable (constructor standings)
linear_features <- constructor_analysis %>%
  select(position, constructorId, raceId, points = points.x, wins, year, circuitId) %>%
  na.omit()

# Split data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(linear_features$position, p = .7, list = FALSE)
trainData <- linear_features[trainIndex, ]
testData <- linear_features[-trainIndex, ]

# Fit the Linear Regression model
linear_model <- lm(position ~ ., data = trainData)

# Predict on test data
linear_predictions <- predict(linear_model, testData)

# Evaluate the model
r_squared <- summary(linear_model)$r.squared
rmse_value <- RMSE(linear_predictions, testData$position)
mae_value <- MAE(linear_predictions, testData$position)

# Output results to a text file
sink(paste0(output_folder, 'constructor_linear_regression_results.txt'))
cat("Linear Regression Model Summary:\n")
print(summary(linear_model))
cat("\nR-squared: ", r_squared)
cat("\nRMSE: ", rmse_value)
cat("\nMAE: ", mae_value, "\n")
sink()

# Plotting Actual vs Predicted Constructor Standings
constructor_plot <- ggplot(testData, aes(x = position, y = linear_predictions)) +
  geom_point(color = 'blue') +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Actual vs Predicted Constructor Standings", x = "Actual Standing", y = "Predicted Standing") +
  theme_minimal()

# Save the plot
ggsave(paste0(output_folder, 'constructor_linear_regression_plot.png'), plot = constructor_plot)
