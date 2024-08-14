# Load necessary libraries
library(dplyr)

# Load datasets
qualifying <- read.csv("data/qualifying.csv")
races <- read.csv("data/races.csv")
drivers <- read.csv("data/drivers.csv")

# Merge qualifying with races
qualifying_races <- merge(qualifying, races, by = "raceId")

# Merge with drivers
merged_qualifying <- merge(qualifying_races, drivers, by = "driverId")

# Optional: Save the merged dataset to a CSV file for further analysis
write.csv(merged_qualifying, "merged_qualifying.csv", row.names = FALSE)

# Output a summary to a text file
summary_output <- capture.output(summary(merged_qualifying))
writeLines(summary_output, "merged_qualifying_summary.txt")

# View the first few rows of the merged dataset
head(merged_qualifying)
