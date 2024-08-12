# Load the necessary libraries
library(dplyr)
library(tidyr)

# Load the datasets
circuits <- read.csv("circuits.csv")
constructor_results <- read.csv("constructor_results.csv")
constructor_standings <- read.csv("constructor_standings.csv")
constructors <- read.csv("constructors.csv")
driver_standings <- read.csv("driver_standings.csv")
drivers <- read.csv("drivers.csv")
lap_times <- read.csv("lap_times.csv")
pit_stops <- read.csv("pit_stops.csv")
qualifying <- read.csv("qualifying.csv")
races <- read.csv("races.csv")
results <- read.csv("results.csv")
seasons <- read.csv("seasons.csv")
sprint_results <- read.csv("sprint_results.csv")
status <- read.csv("status.csv")

# Race Results Analysis
race_results <- results %>%
  inner_join(races, by = "raceId") %>%
  inner_join(drivers, by = "driverId") %>%
  inner_join(constructors, by = "constructorId")

# Driver Performance Over Time
driver_performance <- driver_standings %>%
  inner_join(drivers, by = "driverId") %>%
  inner_join(seasons, by = "year")

# Constructor Performance Over Time
constructor_performance <- constructor_standings %>%
  inner_join(constructors, by = "constructorId")

# Lap Times and Pit Stops Analysis
performance_metrics <- lap_times %>%
  inner_join(pit_stops, by = c("raceId", "driverId"))

# Qualifying Performance Analysis
qualifying_performance <- qualifying %>%
  inner_join(drivers, by = "driverId") %>%
  inner_join(races, by = "raceId")

# Constructor Analysis
constructor_analysis <- constructor_standings %>%
  inner_join(constructor_results, by = c("raceId", "constructorId")) %>%
  inner_join(constructors, by = "constructorId")

# Save the merged datasets
write.csv(race_results, "race_results_merged.csv", row.names = FALSE)
write.csv(driver_performance, "driver_performance_merged.csv", row.names = FALSE)
write.csv(constructor_performance, "constructor_performance_merged.csv", row.names = FALSE)
write.csv(performance_metrics, "performance_metrics_merged.csv", row.names = FALSE)
write.csv(qualifying_performance, "qualifying_performance_merged.csv", row.names = FALSE)
write.csv(constructor_analysis, "constructor_analysis_merged.csv", row.names = FALSE)
