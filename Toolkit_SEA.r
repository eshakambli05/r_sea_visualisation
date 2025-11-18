#Esha Kambli
#2301
# Install required packages if not already installed
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(readr)) install.packages("readr")
if(!require(scales)) install.packages("scales")
if(!require(reshape2)) install.packages("reshape2")

library(tidyverse)
library(ggplot2)
library(readr)
library(scales)
library(reshape2)

# --------------------------------------------
# 1. READ DATA
# --------------------------------------------
df <- read_csv("country_wise_latest.csv")

# --------------------------------------------
# 2. CLEAN NUMERIC COLUMNS
# --------------------------------------------
num_cols <- c("Confirmed", "Deaths", "Recovered", "Active", 
              "New cases", "New deaths", "New recovered",
              "Deaths / 100 Cases", "Recovered / 100 Cases",
              "Deaths / 100 Recovered", "Confirmed last week",
              "1 week change", "1 week % increase")

for (col in num_cols) {
  if (col %in% names(df)) {
    df[[col]] <- as.numeric(df[[col]])
  }
}

# Automatically detect "Country" column
country_col <- names(df)[str_detect(names(df), regex("country", ignore_case = TRUE))][1]
if (is.na(country_col)) {
  country_col <- "Country"
}

# --------------------------------------------
# 3. PLOT 1 – TOP 10 COUNTRIES BY CONFIRMED CASES
# --------------------------------------------
top10_cases <- df %>% 
  arrange(desc(Confirmed)) %>% 
  slice(1:10)

ggplot(top10_cases, aes(x = reorder(!!sym(country_col), Confirmed), y = Confirmed)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  theme_minimal() +
  labs(title="Top 10 Countries by Confirmed Cases",
       x="Country", y="Confirmed Cases")

# --------------------------------------------
# 4. PLOT 2 – DEATHS vs CONFIRMED CASES
# --------------------------------------------
ggplot(df, aes(x = Confirmed, y = Deaths)) +
  geom_point(color="red", alpha=0.6) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  theme_minimal() +
  labs(title="Deaths vs Confirmed Cases",
       x="Confirmed Cases", y="Deaths")

# --------------------------------------------
# 5. PLOT 3 – RECOVERY RATE DISTRIBUTION
# --------------------------------------------
if ("Recovered / 100 Cases" %in% names(df)) {
  ggplot(df, aes(x = `Recovered / 100 Cases`)) +
    geom_histogram(bins = 20, fill="green", color="black") +
    theme_minimal() +
    labs(title="Distribution of Recovery Rate (%)",
         x="Recovery Rate (%)", y="Frequency")
}

# --------------------------------------------
# 6. PLOT 4 – TOP 10 COUNTRIES BY ACTIVE CASES
# --------------------------------------------
top10_active <- df %>% 
  arrange(desc(Active)) %>% 
  slice(1:10)

ggplot(top10_active, aes(x = reorder(!!sym(country_col), Active), y = Active)) +
  geom_bar(stat="identity", fill="orange") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  theme_minimal() +
  labs(title="Top 10 Countries by Active Cases",
       x="Country", y="Active Cases")

# --------------------------------------------
# 7. PLOT 5 – WEEKLY CHANGE VS CONFIRMED LAST WEEK
# --------------------------------------------
if ("1 week change" %in% names(df) && "Confirmed last week" %in% names(df)) {
  ggplot(df, aes(x = `Confirmed last week`, y = `1 week change`)) +
    geom_point(color="purple", alpha=0.6) +
    scale_x_continuous(labels = comma) +
    scale_y_continuous(labels = comma) +
    theme_minimal() +
    labs(title="1 Week Change vs Confirmed Last Week",
         x="Confirmed Last Week",
         y="1 Week Change")
}





