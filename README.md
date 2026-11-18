# Research compendium template

A starting point for an R research project. It's laid out like an R package
(think "R package but for an analysis") so that your functions, data, scripts
and figures each have one obvious home, and anyone (including you in six
months) can rerun the whole thing from start to finish.

It's a lighter version of the ideas in [rrrpkg](https://github.com/ropensci/rrrpkg)
and [rrtools](https://github.com/benmarwick/rrtools). You don't write your
report in here - that can live in Google Docs or wherever you like. This repo
is for the code and data that make your results and figures.

## Getting started

1. Click the green **Use this template** button at the top of this page and
   choose **Create a new repository**. Give it a short name for your project
   (e.g. `resistance-selection`) and put it under your own GitHub account.
2. Get it onto your computer. In RStudio: *File > New Project > Version
   Control > Git*, and paste in your new repo's URL. Or from a terminal:

   ```
   git clone https://github.com/<your-username>/<your-repo>.git
   ```

3. Open the `.Rproj` file, so RStudio starts in the right folder.
4. Install the packages the project needs (listed in `DESCRIPTION`):

   ```r
   install.packages(c("remotes", "devtools"))
   remotes::install_deps()
   ```

5. Make it yours:
   - rename `compendium.Rproj` to `<your-repo>.Rproj`
   - in `DESCRIPTION`, change `Package:` to your project name (letters,
     numbers and dots only, no dashes or spaces), and update the `Title`,
     author and `Description`
   - put your name in `LICENSE` and `LICENSE.md`
   - rewrite this README to say what your project is about
6. Run the four example scripts in `analysis/` in order to check everything
   works. You should end up with `figures/example_plot.png`. Then delete the
   examples and start on your own.

## Layout

```
.
├── DESCRIPTION        # project name and the packages it needs
├── R/                 # your functions
├── analysis/          # numbered scripts, run in order
│   ├── 01_setup.R     # read raw data, tidy it, save to data/processed/
│   ├── 02_run.R       # run the model, save results to outputs/
│   ├── 03_collect.R   # read the saved results back in and combine them
│   └── 04_plots.R     # make figures, save to figures/
├── data/
│   ├── raw/           # data as you got it - never edit by hand
│   └── processed/     # data made by your scripts
├── outputs/           # model results (not uploaded to GitHub)
└── figures/           # figures for your report
```

## How to work

**Raw data is read-only.** Put data exactly as you received it in `data/raw/`
and don't touch it again. Any cleaning or fixing happens in code (e.g.
`01_setup.R`), which saves a tidied copy to `data/processed/`. That way
there's a record of every change.

**Scripts are numbered and run in order.** Each script reads what the earlier
ones saved and saves what the later ones need. If `03_collect.R` needs a file
made by `02_run.R`, the numbering tells you (and anyone else) to run `02`
first. Add new scripts with the next number up.

**Save slow results to file.** If something takes more than a minute or so to
run, save the result with `saveRDS()` and read it back in later with
`readRDS()`, rather than rerunning it every time you want to change a plot.
Results go in `outputs/`, which is in `.gitignore` because model outputs can
get big. Anything in `outputs/` should be possible to recreate by rerunning
the scripts.

**Use `here::here()` for file paths**, e.g.
`here::here("data", "raw", "my_data.csv")`. It always starts from the top of
the project, so scripts work whatever folder you run them from, on any
computer.

**Turn repeated code into functions.** If you copy and paste the same chunk of
code twice, make it a function and put it in a file in `R/`. There's one tiny
example in `R/logistic_growth.R`.

## Loading your functions

At the top of each script:

```r
devtools::load_all()
```

This loads every function in `R/` (and is what the example scripts do). In
RStudio the shortcut is Ctrl/Cmd + Shift + L. If you'd rather not use
devtools, `source()` each file instead:

```r
invisible(lapply(list.files(here::here("R"), full.names = TRUE), source))
```

## Packages

`DESCRIPTION` is where the project's packages are listed. It isn't a package
you need to build or install, it's just a tidy list so that
`remotes::install_deps()` can install everything in one go. When you start
using a new package, add it under `Imports:` (`usethis::use_package("dplyr")`
does this for you). If a package isn't on CRAN, add a `Remotes:` line, e.g.
`Remotes: github-username/packagename`.

## Git habits

- **Commit little and often.** Every time something works, or you finish a
  small piece, commit it. Small commits are much easier to undo than big ones.
- **Write a short message saying what changed**, e.g. "add function to
  simulate drug use" or "fix units in prevalence plot". Future you will thank
  you.
- **Push at the end of each day** so your work is backed up on GitHub (and
  your supervisor can see it).
- **Pull before you start** if you work on more than one computer.
- **Don't commit big files** (more than a few MB). Put big outputs in
  `outputs/` and keep them out of git. If raw data is big or can't be shared,
  keep it out of git too and say in this README where to get it.

In RStudio, the *Git* tab has buttons for all of this (Commit, Push, Pull).
[Happy Git and GitHub for the useR](https://happygitwithr.com) is a good guide
if you get stuck.

## Running jobs on the DIDE cluster (optional)

If you need to run lots of slow model runs (e.g. a big parameter sweep), you
can send them to the DIDE cluster with
[hipercow](https://mrc-ide.github.io/hipercow/). Read the
[hipercow docs](https://mrc-ide.github.io/hipercow/articles/hipercow.html) and
the [DIDE cluster guide](https://mrc-ide.github.io/hipercow/articles/dide-cluster.html)
first. In short:

1. You need a DIDE account, to be on the DIDE network (or ZScaler), and your
   project folder must be on a network share the cluster can see (e.g. a
   mapped drive, not your laptop's own disk).
2. Install hipercow:

   ```r
   install.packages(
     "hipercow",
     repos = c("https://mrc-ide.r-universe.dev", "https://cloud.r-project.org"))
   ```

3. Set it up once per project, from the top of the project:

   ```r
   library(hipercow)
   hipercow_init(driver = "dide-windows")

   # tell the cluster which packages to install: list them, one per line, in
   # a file called pkgdepends.txt at the top of the project, then
   hipercow_provision()

   # make your functions in R/ available to cluster jobs
   hipercow_environment_create(sources = list.files("R", full.names = TRUE))
   ```

4. Send off one job per row of a parameter table, wait, then collect them:

   ```r
   pars <- expand.grid(r = c(0.2, 0.25, 0.3), p0 = c(0.03, 0.05))
   b <- task_create_bulk_expr(logistic_growth(seq(0, 20, by = 0.5), r, p0), pars)
   hipercow_bundle_status(b)
   hipercow_bundle_wait(b)
   res <- hipercow_bundle_result(b)
   saveRDS(res, here::here("outputs", "cluster_results.rds"))
   ```

hipercow's working files go in a `hipercow/` folder, which is already in
`.gitignore`.

## Licence

Code is under the [MIT licence](LICENSE.md). Change the name in `LICENSE` and
`LICENSE.md` to your own.
