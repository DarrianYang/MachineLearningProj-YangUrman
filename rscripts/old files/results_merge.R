# Load necessary libraries
library(dplyr)

# Load datasets
results <- read.csv("data/results.csv")
races <- read.csv("data/races.csv")
drivers <- read.csv("data/drivers.csv")
constructors <- read.csv("data/constructors.csv")

# Merge results with races
results_races <- merge(results, races, by = "raceId")

# Merge with drivers
results_races_drivers <- merge(results_races, drivers, by = "driverId")

# Merge with constructors
merged_race_results <- merge(results_races_drivers, constructors, by = "constructorId")

# Optional: Save the merged dataset to a CSV file for further analysis
write.csv(merged_race_results, "data/merged_race_results.csv", row.names = FALSE)

# Output a summary to a text file
summary_output <- capture.output(summary(merged_race_results))
writeLines(summary_output, "data/merged_race_results_summary.txt")

# View the first few rows of the merged dataset
head(merged_race_results)
