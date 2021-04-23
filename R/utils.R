#' Internal Stopifnot Procedure
#'
#' Check that inputs to each time-period argument of \code{\link{r2cron}} are
#' valid.
#'
#' @param x The user's input for a time period argument in the
#'     \code{\link{r2cron}} function
#' @param p Valid cron time periods used in the \code{\link{r2cron}} function.
#'
#' @return Error if it fails.
#'
.stop <- function(x, p = c("minutes", "hours", "days_month",
                           "months", "days_week")) {

  # Set integer ranges for each valid cron time-period
  r <- if (p == "minutes") {
    0L:59L
  } else if (p == "hours") {
    0L:23L
  } else if (p == "days_month") {
    1L:31L
  } else if (p == "months") {
    1L:12L
  } else if (p == "days_week") {
    1L:7L
  }

  if (is.logical(x) |
      is.character(x) & !all(x == "*") |
      is.numeric(x) & !all(x %in% r)) {

    # Fail if input is outside valid range for the time period
    stop(
      paste0(
        "'", p, "' argument must be integers from ",
        min(r), " to ", max(r)
      )
    )

  }

}

#' Internal R Expression to Cron String Procedure
#'
#' Convert time-period arguments of \code{\link{r2cron}} from R expressions to
#' the most appropriate cron expression format and paste them together.
#'
#' @param x The user's input for a time period argument in the
#'     \code{\link{r2cron}} function
#' @param p Valid cron time periods used in the \code{\link{r2cron}} function.
#'
#' @return A character string.
#'
.as_cron <- function(x, p) {

  if ((p == "minutes" & length(x) == 60 & all(x %in% 0L:59L)) |
      (p == "hours" & length(x) == 24 & all(x %in% 0L:23L)) |
      (p == "days_month" & length(x) == 31 & all(x %in% 1L:31L)) |
      (p == "months" & length(x) == 12 & all(x %in% 1L:12L)) |
      (p == "days_week" & length(x) == 7 & all(x %in% 0L:6L))) {

    "*"  # i.e. every unit of the time period

  } else if (is.numeric(x) & length(x) == 1) {

    as.character(x)  # i.e. 1 becomes "1"

  } else if (is.numeric(x) & length(x) > 1 & all(diff(x) == 1)) {

    paste0(x[1], "-", x[length(x)])  # i.e. 1:3 becomes "1-3"

  } else if (is.numeric(x) & length(x) > 2 & length(unique(diff(x))) == 1) {

    if (p == "minutes" & length(x) == length(seq(x[1], 59, unique(diff(x)))) |
        p == "hours" & length(x) == length(seq(x[1], 23, unique(diff(x)))) |
        p == "days_month" & length(x) == length(seq(x[1], 31, unique(diff(x)))) |
        p == "months" & length(x) == length(seq(x[1], 12, unique(diff(x)))) |
        p == "days_week" & length(x) == length(seq(x[1], 6, unique(diff(x))))) {

      paste0(x[1], "/", unique(diff(x)))  # i.e. seq(0, 59, 20) is "0/20"

    }

  } else {

    paste0(x, collapse = ",")  # i.e. c(1, 2, 5) becomes "1,2,5"

  }

}

#' Convert a Vector to a Sentence
#'
#' Paste elements of a vector into sentence form, so that items are separated by
#' commas and the last is separated with the word 'and'. Used for output in
#' \code{\link{cron2eng}}.
#'
#' @param x A vector.
#'
#' @return A character string.
#'
.vec2eng <- function(x) {

  if(!is.atomic(x)) {
    stop(".vec2eng input must be a vector")
  }

  if (length(x) == 1) {
    x
  } else if (length(x) > 1) {
    paste(paste(x[1:length(x)-1], collapse = ", "), "and", x[length(x)])
  }

}
