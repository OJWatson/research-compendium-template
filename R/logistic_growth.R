#' Logistic growth
#'
#' An example function - replace it with your own. Anything you write more
#' than once in your analysis scripts should become a function in R/.
#'
#' @param time Vector of times
#' @param r Growth rate
#' @param p0 Starting proportion (between 0 and 1)
#'
#' @return Proportion at each time
logistic_growth <- function(time, r, p0) {
  p0 * exp(r * time) / (1 - p0 + p0 * exp(r * time))
}
