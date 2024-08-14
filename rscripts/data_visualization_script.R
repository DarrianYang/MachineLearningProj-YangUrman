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

# 1. Race Results Analysis
# Distribution of finishing positions
finishing_position_plot <- ggplot(race_results, aes(x = positionOrder)) +
  geom_histogram(binwidth = 1, fill = 'blue', color = 'black') +
  labs(title = 'Distribution of Finishing Positions', x = 'Finishing Position', y = 'Count')
ggsave(paste0(output_folder, 'finishing_position_distribution.png'), plot = finishing_position_plot)

# Points distribution for drivers and constructors
points_distribution_plot <- ggplot(race_results, aes(x = points)) +
  geom_histogram(binwidth = 1, fill = 'green', color = 'black') +
  facet_wrap(~ constructorId) +
  labs(title = 'Points Distribution for Drivers and Constructors', x = 'Points', y = 'Count')
ggsave(paste0(output_folder, 'points_distribution.png'), plot = points_distribution_plot)

# Relationship between starting grid position and final position
ggplot(race_results, aes(x = grid, y = positionOrder)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm', color = 'red') +
  labs(title = 'Starting Grid Position vs. Final Position', x = 'Grid Position', y = 'Final Position') +
  ggsave(paste0(output_folder, 'grid_vs_final_position.png'))

# 2. Driver Performance Over Time
# Trends in driver standings over seasons
ggplot(driver_performance, aes(x = year, y = position, group = driverId, color = driverId)) +
  geom_line(alpha = 0.7) +
  labs(title = 'Driver Standings Over Time', x = 'Year', y = 'Position') +
  ggsave(paste0(output_folder, 'driver_standings_over_time.png'))

# Points accumulated by drivers over time
ggplot(driver_performance, aes(x = year, y = points, group = driverId, color = driverId)) +
  geom_line(alpha = 0.7) +
  labs(title = 'Points Accumulated by Drivers Over Time', x = 'Year', y = 'Points') +
  ggsave(paste0(output_folder, 'driver_points_over_time.png'))

# 3. Qualifying Performance Analysis
# Distribution of qualifying positions
ggplot(qualifying_performance, aes(x = position)) +
  geom_histogram(binwidth = 1, fill = 'purple', color = 'black') +
  labs(title = 'Distribution of Qualifying Positions', x = 'Qualifying Position', y = 'Count') +
  ggsave(paste0(output_folder, 'qualifying_position_distribution.png'))

# Relationship between qualifying position and race finish position
ggplot(qualifying_performance, aes(x = position, y = positionOrder)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = 'lm', color = 'red') +
  labs(title = 'Qualifying Position vs. Final Race Position', x = 'Qualifying Position', y = 'Final Position') +
  ggsave(paste0(output_folder, 'qualifying_vs_final_position.png'))

# 4. Constructor Analysis
# Constructor standings over time
ggplot(constructor_analysis, aes(x = year, y = position, group = constructorId, color = constructorId)) +
  geom_line(alpha = 0.7) +
  labs(title = 'Constructor Standings Over Time', x = 'Year', y = 'Position') +
  ggsave(paste0(output_folder, 'constructor_standings_over_time.png'))

# Points distribution for constructors
ggplot(constructor_analysis, aes(x = points)) +
  geom_histogram(binwidth = 1, fill = 'orange', color = 'black') +
  labs(title = 'Points Distribution for Constructors', x = 'Points', y = 'Count') +
  ggsave(paste0(output_folder, 'constructor_points_distribution.png'))

