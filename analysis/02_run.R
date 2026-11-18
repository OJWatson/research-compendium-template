# 02_run.R
# Run the model across a set of parameter values.
#
# Each run is saved to outputs/runs/ as it finishes. If a run is slow you
# don't want to repeat it, so save results to file and read them back in
# later scripts, rather than keeping them only in your R session.
# For big parameter sweeps, see the hipercow section of the README.

devtools::load_all()

# parameters to sweep over
pars <- expand.grid(r = c(0.2, 0.25, 0.3), p0 = c(0.03, 0.05))

dir.create(here::here("outputs", "runs"), recursive = TRUE, showWarnings = FALSE)

for (i in seq_len(nrow(pars))) {
  time <- seq(0, 20, by = 0.5)
  res <- data.frame(
    run = i,
    r = pars$r[i],
    p0 = pars$p0[i],
    time = time,
    prevalence = logistic_growth(time, pars$r[i], pars$p0[i])
  )
  saveRDS(res, here::here("outputs", "runs", paste0("run_", i, ".rds")))
}
