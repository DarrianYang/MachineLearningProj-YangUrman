# Load necessary libraries
library(dplyr)

# Define the data folder and output directory
output_folder <- './'

# Load the cleaned datasets
circuits <- read.csv('circuits_cleaned.csv')
constructor_results <- read.csv('constructor_results_cleaned.csv')
constructor_standings <- read.csv('constructor_standings_cleaned.csv')
constructors <- read.csv('constructors_cleaned.csv')
driver_standings <- read.csv('driver_standings_cleaned.csv')
drivers <- read.csv('drivers_cleaned.csv')
lap_times <- read.csv('lap_times_cleaned.csv')
pit_stops <- read.csv('pit_stops_cleaned.csv')
qualifying <- read.csv('qualifying_cleaned.csv')
races <- read.csv('races_cleaned.csv')
results <- read.csv('results_cleaned.csv')
seasons <- read.csv('seasons_cleaned.csv')
sprint_results <- read.csv('sprint_results_cleaned.csv')
status <- read.csv('status_cleaned.csv')

# 1. Race Results Analysis: Merge results.csv with races.csv, drivers.csv, and constructors.csv
race_results <- results %>%
  left_join(races, by = "raceId") %>%
  left_join(drivers, by = "driverId") %>%
  left_join(constructors, by = "constructorId") %>%
  left_join(circuits, by = "circuitId")

# 2. Driver Performance Over Time: Correct the merge by joining driver_standings with races first to get the year
driver_performance <- driver_standings %>%
  left_join(races, by = "raceId") %>%
  left_join(drivers, by = "driverId") %>%
  left_join(seasons, by = "year") %>%
  left_join(results, by = c("raceId", "driverId"))

# 3. Qualifying Performance Analysis: Merge qualifying.csv with drivers.csv, races.csv, and constructors.csv
qualifying_performance <- qualifying %>%
  left_join(drivers, by = "driverId") %>%
  left_join(races, by = "raceId") %>%
  left_join(constructors, by = "constructorId")

# 4. Constructor Analysis: Merge constructor_standings.csv with constructors.csv, constructor_results.csv, and races.csv
constructor_analysis <- constructor_standings %>%
  left_join(constructors, by = "constructorId") %>%
  left_join(constructor_results, by = c("raceId", "constructorId")) %>%
  left_join(races, by = "raceId")

# Save the merged datasets
write.csv(race_results, paste0(output_folder, 'race_results_merged.csv'), row.names = FALSE)
write.csv(race_results_detailed, paste0(output_folder, 'race_results_detailed_merged.csv'), row.names = FALSE)
write.csv(driver_performance, paste0(output_folder, 'driver_performance_merged.csv'), row.names = FALSE)
write.csv(qualifying_performance, paste0(output_folder, 'qualifying_performance_merged.csv'), row.names = FALSE)
write.csv(constructor_analysis, paste0(output_folder, 'constructor_analysis_merged.csv'), row.names = FALSE)

