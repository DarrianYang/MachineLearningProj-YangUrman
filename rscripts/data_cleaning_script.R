# Load necessary libraries
library(dplyr)

# Define the data folder and output directory
data_folder <- 'data/'
output_folder <- './'

# Load the datasets
circuits <- read.csv(paste0(data_folder, 'circuits.csv'))
constructor_results <- read.csv(paste0(data_folder, 'constructor_results.csv'))
constructor_standings <- read.csv(paste0(data_folder, 'constructor_standings.csv'))
constructors <- read.csv(paste0(data_folder, 'constructors.csv'))
driver_standings <- read.csv(paste0(data_folder, 'driver_standings.csv'))
drivers <- read.csv(paste0(data_folder, 'drivers.csv'))
lap_times <- read.csv(paste0(data_folder, 'lap_times.csv'))
pit_stops <- read.csv(paste0(data_folder, 'pit_stops.csv'))
qualifying <- read.csv(paste0(data_folder, 'qualifying.csv'))
races <- read.csv(paste0(data_folder, 'races.csv'))
results <- read.csv(paste0(data_folder, 'results.csv'))
seasons <- read.csv(paste0(data_folder, 'seasons.csv'))
sprint_results <- read.csv(paste0(data_folder, 'sprint_results.csv'))
status <- read.csv(paste0(data_folder, 'status.csv'))

# Handle missing values in qualifying data
# Fill missing q2 and q3 times with NA (for drivers who didn't reach those stages)
qualifying <- qualifying %>%
  mutate(q2 = ifelse(is.na(q2), NA, q2),
         q3 = ifelse(is.na(q3), NA, q3))

# Save the cleaned data back to CSV files in the same directory as the script
write.csv(circuits, paste0(output_folder, 'circuits_cleaned.csv'), row.names = FALSE)
write.csv(constructor_results, paste0(output_folder, 'constructor_results_cleaned.csv'), row.names = FALSE)
write.csv(constructor_standings, paste0(output_folder, 'constructor_standings_cleaned.csv'), row.names = FALSE)
write.csv(constructors, paste0(output_folder, 'constructors_cleaned.csv'), row.names = FALSE)
write.csv(driver_standings, paste0(output_folder, 'driver_standings_cleaned.csv'), row.names = FALSE)
write.csv(drivers, paste0(output_folder, 'drivers_cleaned.csv'), row.names = FALSE)
write.csv(lap_times, paste0(output_folder, 'lap_times_cleaned.csv'), row.names = FALSE)
write.csv(pit_stops, paste0(output_folder, 'pit_stops_cleaned.csv'), row.names = FALSE)
write.csv(qualifying, paste0(output_folder, 'qualifying_cleaned.csv'), row.names = FALSE)
write.csv(races, paste0(output_folder, 'races_cleaned.csv'), row.names = FALSE)
write.csv(results, paste0(output_folder, 'results_cleaned.csv'), row.names = FALSE)
write.csv(seasons, paste0(output_folder, 'seasons_cleaned.csv'), row.names = FALSE)
write.csv(sprint_results, paste0(output_folder, 'sprint_results_cleaned.csv'), row.names = FALSE)
write.csv(status, paste0(output_folder, 'status_cleaned.csv'), row.names = FALSE)
