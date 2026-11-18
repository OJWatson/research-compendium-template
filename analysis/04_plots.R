# 04_plots.R
# Make the figures. Figures are saved in figures/ so they can go into your
# report. Rerun this script whenever the results change.

devtools::load_all()
library(ggplot2)

results <- readRDS(here::here("outputs", "results.rds"))
observed <- readRDS(here::here("data", "processed", "example_data.rds"))

gg <- ggplot(results, aes(time, prevalence)) +
  geom_line(aes(colour = factor(r), linetype = factor(p0))) +
  geom_point(data = observed) +
  labs(x = "Time", y = "Prevalence", colour = "r", linetype = "p0") +
  theme_bw()

ggsave(here::here("figures", "example_plot.png"), gg, width = 6, height = 4)
