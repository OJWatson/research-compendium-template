# 03_collect.R
# Read the saved runs back in and combine them into one data frame.

devtools::load_all()

files <- list.files(here::here("outputs", "runs"), full.names = TRUE)
results <- do.call(rbind, lapply(files, readRDS))

saveRDS(results, here::here("outputs", "results.rds"))
