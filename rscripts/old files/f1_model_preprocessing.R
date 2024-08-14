# Load necessary libraries
library(dplyr)
library(caret)
library(ggplot2)

# Load the merged datasets (adjust paths as needed)
race_results <- read.csv("race_results_merged.csv")
driver_performance <- read.csv("driver_performance_merged.csv")
constructor_performance <- read.csv("constructor_performance_merged.csv")
sprint_race_results <- read.csv("sprint_race_results_merged.csv")
performance_metrics <- read.csv("performance_metrics_merged.csv")
qualifying_performance <- read.csv("qualifying_performance_merged.csv")

# Function to process each dataset
process_dataset <- function(dataset, dataset_name) {
  # Step 1: Scale and Normalize Features
  
  # Check if 'points' and 'win' columns exist and exclude them if they do
  if ("points" %in% names(dataset) & "win" %in% names(dataset)) {
    numeric_features <- dataset %>% 
      select_if(is.numeric) %>%
      select(-points, -win)  # Exclude target variables from scaling
  } else {
    numeric_features <- dataset %>% 
      select_if(is.numeric)  # Just select all numeric features if 'points' and 'win' don't exist
  }
  
  scaled_features <- scale(numeric_features)
  write.table(scaled_features, file = paste0("scaled_features_", dataset_name, ".txt"), sep = "\t")
  
  # Step 2: Apply PCA (Optional)
  pca_result <- prcomp(scaled_features, center = TRUE, scale. = TRUE)
  pca_summary <- summary(pca_result)
  write.table(pca_summary$importance, file = paste0("pca_summary_", dataset_name, ".txt"), sep = "\t")
  
  # Plot PCA
  pca_plot <- ggplot(as.data.frame(pca_result$x), aes(x = PC1, y = PC2)) +
    geom_point(alpha = 0.5) +
    ggtitle(paste("PCA of F1 Dataset -", dataset_name)) +
    theme_minimal()
  
  # Save the PCA plot
  ggsave(paste0("pca_plot_", dataset_name, ".png"), pca_plot)
  
  # Save the PCA-transformed data
  pca_transformed_data <- as.data.frame(pca_result$x)
  write.table(pca_transformed_data, file = paste0("pca_transformed_data_", dataset_name, ".txt"), sep = "\t")
  
  # Save the final preprocessed dataset
  save(dataset, scaled_features, pca_result, file = paste0("preprocessed_f1_data_", dataset_name, ".RData"))
}

# Process each dataset individually
process_dataset(race_results, "race_results")
process_dataset(driver_performance, "driver_performance")
process_dataset(constructor_performance, "constructor_performance")
process_dataset(sprint_race_results, "sprint_race_results")
process_dataset(performance_metrics, "performance_metrics")
process_dataset(qualifying_performance, "qualifying_performance")

