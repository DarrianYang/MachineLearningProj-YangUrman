# Load necessary libraries
library(dplyr)
library(ggplot2)
library(factoextra)

# Load the merged driver performance dataset
driver_performance <- read.csv("merged_driver_performance.csv")

# Select relevant numerical columns for PCA
pca_data <- driver_performance %>% select(points, wins, position)

# Perform PCA
pca_result <- prcomp(pca_data, scale = TRUE)

# Save the PCA summary to a text file
pca_summary <- capture.output(summary(pca_result))
writeLines(pca_summary, "pca_summary.txt")

# Plot the PCA results without ellipses and with a different color scheme
# Switching to a palette that can handle more values or removing the palette to avoid the limitation
# Option 1: Use a different variable for coloring, such as nationality
fviz_pca_ind(pca_result, geom.ind = "point", pointshape = 21, 
             pointsize = 2, fill.ind = driver_performance$nationality, 
             label = "var") + 
  ggtitle("PCA of Driver Performance Over Time") +
  theme_minimal()

# Save the plot
ggsave("pca_driver_performance_plot.png")
