# Load necessary libraries
library(dplyr)

# Load datasets
driver_standings <- read.csv("data/driver_standings.csv")
drivers <- read.csv("data/drivers.csv")
seasons <- read.csv("data/seasons.csv")
races <- read.csv("data/races.csv")

# Merge driver_standings with races to get the year
driver_standings_races <- merge(driver_standings, races, by = "raceId")

# Merge the result with drivers to get driver information
driver_standings_races_drivers <- merge(driver_standings_races, drivers, by = "driverId")

# Now merge with seasons to get the full dataset
merged_driver_performance <- merge(driver_standings_races_drivers, seasons, by = "year")

# Optional: Save the merged dataset to a CSV file for further analysis
write.csv(merged_driver_performance, "merged_driver_performance.csv", row.names = FALSE)

# Output a summary to a text file
summary_output <- capture.output(summary(merged_driver_performance))
writeLines(summary_output, "merged_driver_performance_summary.txt")

# View the first few rows of the merged dataset
head(merged_driver_performance)