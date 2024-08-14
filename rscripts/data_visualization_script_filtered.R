# Load necessary libraries
library(ggplot2)
library(dplyr)

# Define the output directory
output_folder <- './'

# Load the merged datasets
race_results <- read.csv('race_results_merged.csv')
driver_performance <- read.csv('driver_performance_merged.csv')
qualifying_performance <- read.csv('qualifying_performance_merged.csv')
constructor_analysis <- read.csv('constructor_analysis_merged.csv')

# Filter data to include only positions 1-20
race_results_filtered <- race_results %>%
  filter(positionOrder <= 20)

# 1. Race Results Analysis - Focus on Positions 1-20
# Distribution of finishing positions
finishing_position_plot <- ggplot(race_results_filtered, aes(x = positionOrder)) +
  geom_histogram(binwidth = 1, fill = 'blue', color = 'black') +
  labs(title = 'Distribution of Finishing Positions (1-20)', x = 'Finishing Position', y = 'Count')
ggsave(paste0(output_folder, 'finishing_position_distribution_filtered.png'), plot = finishing_position_plot)

# Points distribution for drivers and constructors
points_distribution_plot <- ggplot(race_results_filtered, aes(x = points)) +
  geom_histogram(binwidth = 5, fill = 'green', color = 'black') +
  facet_wrap(~ constructorId) +
  labs(title = 'Points Distribution for Drivers and Constructors (1-20)', x = 'Points', y = 'Count')
ggsave(paste0(output_folder, 'points_distribution_filtered.png'), plot = points_distribution_plot)

# Relationship between starting grid position and final position
grid_vs_final_position_plot <- ggplot(race_results_filtered, aes(x = grid, y = positionOrder)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm', color = 'red') +
  labs(title = 'Starting Grid Position vs. Final Position (1-20)', x = 'Grid Position', y = 'Final Position')
ggsave(paste0(output_folder, 'grid_vs_final_position_filtered.png'), plot = grid_vs_final_position_plot)
