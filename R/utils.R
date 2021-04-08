.stop <- function(x, p) {

 range <-
  if (p == "minutes") {
   0L:59L
  } else if (p== "hours") {
   0L:23L
  } else if (p == "days_month") {
   1L:31L
  } else if (p == "months") {
   1L:12L
  } else if (p == "days_week") {
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

.as_cron <- function(x, p) {

 if (is.character(x) | (is.numeric(x) & length(x) == 1)) {

  as.character(x)

 } else if (is.numeric(x) & length(x) > 1 & all(diff(x) == 1)) {

  paste0(x[1], "-", x[length(x)])

 } else if (is.numeric(x) &
            length(x) > 1 &
            length(unique(diff(x))) == 1) {

   if (
     p == "minutes" & length(x) == length(seq(x[1], 59, unique(diff(x)))) |
     p == "hours" & length(x) == length(seq(x[1], 23, unique(diff(x)))) |
     p == "days_month" & length(x) == length(seq(x[1], 31, unique(diff(x)))) |
     p == "months" & length(x) == length(seq(x[1], 12, unique(diff(x)))) |
     p == "days_week" & length(x) == length(seq(x[1], 6, unique(diff(x))))
   ) {

     paste0(x[1], "/", unique(diff(x)))

   } else {

     paste0(x, collapse = ",")

  }

 } else {

  paste0(x, collapse = ",")

 }

}
