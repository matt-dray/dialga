.stop <- function(x, period) {

 range <-
  if (period == "minutes") {
   0L:59L
  } else if (period == "hours") {
   0L:23L
  } else if (period == "days_month") {
   1L:31L
  } else if (period == "months") {
   1L:12L
  } else if (period == "days_week") {
   0L:6L
  }

 if (is.character(x) & !all(x == "*") |
     is.numeric(x) & !all(x %in% range)) {
  stop(
   paste0(
    "'", period, "' argument must be an asterisk or integers ",
    min(range), " to ", max(range))
  )
 }

}

.as_cron <- function(x) {

 if (is.character(x) | (is.numeric(x) & length(x) == 1)) {

  as.character(x)

 } else if (is.numeric(x) & length(x) > 1 & all(diff(x) == 1)) {

  paste0(x[1], "-", x[length(x)])

 } else if (is.numeric(x) &
            length(x) > 1 &
            length(unique(diff(x))) == 1) {

  if (length(x) == length(seq(x[1], 59, unique(diff(x))))) {

   paste0(x[1], "/", unique(diff(x)))

  } else {

    paste0(x, collapse = ",")

  }

 } else {

  paste0(x, collapse = ",")

 }

}
