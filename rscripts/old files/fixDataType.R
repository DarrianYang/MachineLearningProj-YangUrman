# Load necessary libraries
library(dplyr)
library(tidyr)  # For drop_na()

# Load the dataset with temporary column type as 'character' for flexibility in handling issues
merged_driver_performance <- read.csv("merged_driver_performance.csv", stringsAsFactors = FALSE)

# Replace "\\N" with NA in character columns
merged_driver_performance <- merged_driver_performance %>%
  mutate(across(where(is.character), ~ na_if(., "\\N")))

# Convert columns to the correct data types
merged_driver_performance <- merged_driver_performance %>%
  mutate(
    year = as.numeric(year),
    driverId = as.numeric(driverId),
    raceId = as.numeric(raceId),
    driverStandingsId = as.numeric(driverStandingsId),
    points = as.numeric(points),
    position = as.numeric(position),
    wins = as.numeric(wins),
    round = as.numeric(round),
    circuitId = as.numeric(circuitId),
    dob = as.Date(dob, format = "%Y-%m-%d")
    # Add other conversions as needed
  )

# Handle any remaining missing data
merged_driver_performance <- merged_driver_performance %>%
  drop_na()

# Check the structure to confirm the data types
str(merged_driver_performance)
