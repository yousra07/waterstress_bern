library(readr)
library(dplyr)
library(lubridate)

# Drakau site TWD data
raw_TWD_data <- read_csv("data-raw/bern_data/drakau_TWD/tn_timeseries_L2_2024-01-01_2026-06-05_b94a2730-8696-44f3-a1b3-e091979bdc52.csv")
metadata_TWD <- read_csv("data-raw/bern_data/drakau_TWD/tn_metadata_L2_2024-01-01_2026-06-05_b94a2730-8696-44f3-a1b3-e091979bdc52.csv")

# Aggregate to daily data
df_daily_TWD <- raw_TWD_data |>
  mutate(date = as_date(ts)) |>
  group_by(date, series_id) |>
  summarise(
    TWD_mean = mean(twd, na.rm = TRUE),
    TWD_median = median(twd, na.rm = TRUE),
    TWD_min = min(twd, na.rm = TRUE),
    TWD_max = max(twd, na.rm = TRUE),
    n_obs = n(),
    .groups = "drop"
  ) |>
  filter(month(date) >= 4, month(date) <= 10) |>
  left_join(metadata_TWD, by = "series_id")

# Create output directory
dir.create("data/drakau_data", recursive = TRUE, showWarnings = FALSE)

# Save daily data
write_csv(df_daily_TWD, "data/drakau_data/daily_TWD_drakau.csv")
