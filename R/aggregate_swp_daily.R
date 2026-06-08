library(readr)
library(dplyr)
library(lubridate)

# Drakau site SWP data
metadata_drakau <- read_csv("data-raw/bern_data/drakau_SWP/tn_metadata_L1_2025-01-01_2026-06-05_63b0063f-94a1-4f4d-801a-931c18e57165.csv")
SWPdata_drakau <- read_csv("data-raw/bern_data/drakau_SWP/tn_timeseries_L1_2025-01-01_2026-06-05_63b0063f-94a1-4f4d-801a-931c18e57165.csv")

df_drakau_daily <- SWPdata_drakau |>
  left_join(metadata_drakau, by = "series_id") |>
  mutate(date = as_date(ts)) |>
  group_by(date, series_id) |>
  summarise(
    SWP_mean = mean(value, na.rm = TRUE),
    SWP_median = median(value, na.rm = TRUE),
    SWP_min = min(value, na.rm = TRUE),
    SWP_max = max(value, na.rm = TRUE),
    n_obs = n(),
    .groups = "drop"
  ) |>
  filter(month(date) >= 4, month(date) <= 10) |>
  left_join(metadata_drakau, by = "series_id")

# Save daily data
dir.create("data/drakau_data", recursive = TRUE)
write_csv(df_drakau_daily, "data/drakau_data/daily_SWP_drakau.csv")
