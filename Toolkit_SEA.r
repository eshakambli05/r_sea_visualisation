#Esha Kambli
#2301


if(!require(tidyverse)) install.packages("tidyverse")
if(!require(scales))   install.packages("scales")
library(tidyverse)
library(scales)

# 1. READ DATA
df <- read_csv("country_wise_latest.csv")

# 2. CLEAN NUMERIC COLUMNS (your code was already good)
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

# Detect country column name
country_col <- names(df)[str_detect(names(df), regex("country", ignore_case = TRUE))][1]
if(is.na(country_col)) country_col <- names(df)[1]   # fallback

# ───────────────────── START PDF DEVICE ─────────────────────
pdf("COVID19_All_Plots.pdf", width = 11, height = 8, paper = "a4r")

# ───────────────────── PLOT 1 ─────────────────────
p1 <- df %>%
  arrange(desc(Confirmed)) %>%
  slice_head(n = 10) %>%
  ggplot(aes(x = reorder(!!sym(country_col), Confirmed), y = Confirmed)) +
  geom_col(fill = "steelblue", width = 0.7) +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Top 10 Countries by Confirmed Cases", x = "Country", y = "Confirmed Cases") +
  theme_minimal(base_size = 13)
print(p1)

# ───────────────────── PLOT 2 ─────────────────────
p2 <- ggplot(df, aes(x = Confirmed, y = Deaths)) +
  geom_point(color = "red", alpha = 0.7, size = 2) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  labs(title = "Deaths vs Confirmed Cases (Global)", x = "Confirmed Cases", y = "Deaths") +
  theme_minimal(base_size = 13)
print(p2)

# ───────────────────── PLOT 3 ─────────────────────
p3 <- ggplot(df, aes(x = `Recovered / 100 Cases`)) +
  geom_histogram(bins = 25, fill = "#2ecc71", color = "black", alpha = 0.9) +
  labs(title = "Distribution of Recovery Rate (%) Across Countries",
       x = "Recovery Rate (%)", y = "Number of Countries") +
  theme_minimal(base_size = 13)
print(p3)

# ───────────────────── PLOT 4 ─────────────────────
p4 <- df %>%
  arrange(desc(Active)) %>%
  slice_head(n = 10) %>%
  ggplot(aes(x = reorder(!!sym(country_col), Active), y = Active)) +
  geom_col(fill = "orange", width = 0.7) +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Top 10 Countries by Active Cases", x = "Country", y = "Active Cases") +
  theme_minimal(base_size = 13)
print(p4)

# ───────────────────── PLOT 5 ─────────────────────
p5 <- ggplot(df, aes(x = `Confirmed last week`, y = `1 week change`)) +
  geom_point(color = "purple", alpha = 0.7, size = 2) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  labs(title = "1-Week Case Increase vs Cases from Previous Week",
       x = "Confirmed Cases Last Week", y = "New Cases in Past Week") +
  theme_minimal(base_size = 13)
print(p5)

# ───────────────────── CLOSE PDF ─────────────────────
dev.off()

# ───────────────────── FINAL MESSAGE ─────────────────────
cat("All 5 plots have been displayed on screen\n")
cat("A multi-page PDF has been saved as: All_Plots.pdf\n")





