# 01_setup.R
# Read the raw data, tidy it and save a processed copy.
#
# Never edit files in data/raw/ by hand. If something in the raw data needs
# fixing, fix it here in code, so you (and anyone else) can see what changed.

# load the functions in R/
devtools::load_all()

# read the raw data
raw <- read.csv(here::here("data", "raw", "example_data.csv"))

# tidy it: here we just drop missing values
processed <- raw[!is.na(raw$prevalence), ]

# save the processed data for the next scripts
saveRDS(processed, here::here("data", "processed", "example_data.rds"))
