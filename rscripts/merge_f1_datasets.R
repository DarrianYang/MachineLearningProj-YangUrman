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
status <- read.csv("status.csv")
results <- read.csv("results.csv")
seasons <- read.csv("seasons.csv")
sprint_results <- read.csv("sprint_results.csv")

# 1. Race Results Analysis
race_results <- results %>%
  inner_join(races, by = "raceId") %>%
  inner_join(drivers, by = "driverId") %>%
  inner_join(constructors, by = "constructorId") %>%
  inner_join(status, by = "statusId")

# 2. Driver Performance Over Time
driver_performance <- driver_standings %>%
  inner_join(races, by = "raceId") %>%
  inner_join(drivers, by = "driverId")

# 3. Constructor Performance Over Time
constructor_performance <- constructor_standings %>%
  inner_join(races, by = "raceId") %>%
  inner_join(constructors, by = "constructorId")

# 4. Sprint Race Results Analysis
sprint_race_results <- sprint_results %>%
  inner_join(races, by = "raceId") %>%
  inner_join(drivers, by = "driverId") %>%
  inner_join(constructors, by = "constructorId") %>%
  inner_join(status, by = "statusId")

# 5. Lap Times and Pit Stops Analysis (with Aggregation)

# Aggregate lap times: calculate the mean lap time per driver per race
lap_times_agg <- lap_times %>%
  group_by(raceId, driverId) %>%
  summarize(mean_lap_time = mean(as.numeric(milliseconds)), .groups = 'drop')

# Aggregate pit stops: count the number of pit stops per driver per race
pit_stops_agg <- pit_stops %>%
  group_by(raceId, driverId) %>%
  summarize(total_pit_stops = n(), .groups = 'drop')

# Join the aggregated datasets
performance_metrics <- lap_times_agg %>%
  inner_join(pit_stops_agg, by = c("raceId", "driverId"))

# 6. Qualifying Performance Analysis
qualifying_performance <- qualifying %>%
  inner_join(drivers, by = "driverId") %>%
  inner_join(races, by = "raceId")

# Save the merged datasets for further analysis
write.csv(race_results, "race_results_merged.csv", row.names = FALSE)
write.csv(driver_performance, "driver_performance_merged.csv", row.names = FALSE)
write.csv(constructor_performance, "constructor_performance_merged.csv", row.names = FALSE)
write.csv(sprint_race_results, "sprint_race_results_merged.csv", row.names = FALSE)
write.csv(performance_metrics, "performance_metrics_merged.csv", row.names = FALSE)
write.csv(qualifying_performance, "qualifying_performance_merged.csv", row.names = FALSE)