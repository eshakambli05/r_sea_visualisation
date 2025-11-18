# ----------------------------------------------------
#   R ANALYSIS FOR country_wise_latest.csv
#   Generates: visualizations_from_r.pdf
# ----------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)

# ---- Load Data ----
df <- read_csv("country_wise_latest.csv")

# ---- Check column names ----
print(names(df))

# IMPORTANT:
# Update these column names if your CSV uses different headers.
country_col <- "Country/Region"   # change if needed
total_cases_col <- "Confirmed"
total_deaths_col <- "Deaths"
total_recovered_col <- "Recovered"
new_cases_col <- "New cases"

# Convert numeric columns (avoid factors)
df[[total_cases_col]] <- as.numeric(df[[total_cases_col]])
df[[total_deaths_col]] <- as.numeric(df[[total_deaths_col]])
df[[total_recovered_col]] <- as.numeric(df[[total_recovered_col]])
df[[new_cases_col]] <- as.numeric(df[[new_cases_col]])

# ---- Create PDF with plots ----
pdf("visualizations_from_r.pdf", width = 8, height = 6)

# 1. Top 10 countries by cases
top_cases <- df %>% 
  arrange(desc(.data[[total_cases_col]])) %>%
  slice(1:10)

print(
  ggplot(top_cases,
         aes(x = reorder(.data[[country_col]], .data[[total_cases_col]]),
             y = .data[[total_cases_col]])) +
    geom_col(fill = "steelblue") +
    coord_flip() +
    labs(title = "Top 10 Countries by Confirmed Cases",
         x = "Country",
         y = "Confirmed Cases")
)

# 2. Scatter plot: Deaths vs Cases (log scale helps)
print(
  ggplot(df, aes(x = .data[[total_cases_col]], y = .data[[total_deaths_col]])) +
    geom_point(alpha = 0.6) +
    scale_x_log10() +
    scale_y_log10() +
    labs(title = "Deaths vs Confirmed Cases (log scale)",
         x = "Confirmed Cases",
         y = "Deaths")
)

# 3. Histogram of new cases
print(
  ggplot(df, aes(x = .data[[new_cases_col]])) +
    geom_histogram(bins = 30, fill = "tomato") +
    labs(title = "Distribution of New Cases",
         x = "New Cases",
         y = "Frequency")
)

# 4. Boxplots for main numeric columns
num_cols <- c(total_cases_col, total_deaths_col, total_recovered_col)

for (col in num_cols) {
  print(
    ggplot(df, aes(y = .data[[col]])) +
      geom_boxplot(fill = "skyblue") +
      labs(title = paste("Boxplot of", col),
           y = col)
  )
}

dev.off()

cat("PDF created: visualizations_from_r.pdf\n")
