#' Build A Cron String From R Expressions
#'
#' Provide an R expression to each of the arguments, which are different time
#' periods (minutes, hours, days of the month, months, days of the week), and
#' receive an equivalent cron-expression string in return. See 'arguments' for
#' valid value ranges and 'details' for valid input formats.
#'
#' @param minutes Minutes past the hour, integers 0 to 59 inclusive.
#' @param hours Hours on a 24-hour clock, integers 0 to 23 inclusive.
#' @param days_month Day number of the month, integers 1 to 31 inclusive.
#' @param months Month number, integers 1 to 12 inclusive.
#' @param days_week Day of the week, integers 1 to 7 inclusive (where Sunday is
#'     the first day of the week).
#' @param clip Logical. Copy output to clipboard?
#'
#' @details The time-period arguments default to every unit within that time
#'     period, like 'every minute, of every hour, of every day of the month,
#'     etc'. The following input formats are acceptable inputs to all the time
#'     period arguments:
#' \itemize{
#'   \item a single integer value, like \code{1}
#'   \item consecutive-integer vectors, like \code{1:3}
#'   \item irregularly-spaced integer vectors, like \code{c(2, 3, 5)}
#'   \item regularly-spaced integer sequences with specified start and end
#'   values, like \code{seq(3, 59, 15)} (useful for specifying sequences within
#'   the full time period,'every 15 minutes of the hour starting from minute 3',
#'   like in this example)
#' }
#'
#' @return A character string (copied to the clipboard at the user's
#'     discretion).
#' @export
#'
r2cron <- function(minutes = 0L:59L, hours  = 0L:23L,
                   days_month  = 1L:31L, months = 1L:12L, days_week  = 1L:7L,
                   clip = TRUE) {

 # Stop if input is out of range of time period
 .stop(minutes, "minutes")
 .stop(hours, "hours")
 .stop(days_month, "days_month")
 .stop(months, "months")
 .stop(days_week, "days_week")

 # Zero-index the days of the week
 days_week <- days_week - 1

 # Convert each argument's R expression to equivalent cron expression
 cron_minutes <- .as_cron(minutes, "minutes")
 cron_hours <- .as_cron(hours, "hours")
 cron_days_month <- .as_cron(days_month, "days_month")
 cron_months <- .as_cron(months, "months")
 cron_days_week <- .as_cron(days_week, "days_week")

 # Warn if month and day combinations seem unlikely
 if (cron_months != "*" & cron_days_month != "*" &
   any(months %in% c(2, 4, 6, 9, 11)) & any(days_month == 31)) {
   warning("\n  Sure? There's no 31st in Feb, Apr, Jun, Sept nor Nov.\n")
 }
 if (cron_months != "*" & cron_days_month != "*" &
     any(months == 2) & any(days_month == 30)) {
   warning("\n  Sure? There's no 30th in Feb.\n")
 }
 if (cron_months != "*" & cron_days_month != "*" &
     any(months == 2) & any(days_month == 29)) {
   warning("\n  Sure? 29 Feb is only in leap years.\n")
 }

 # Paste together cron expressions for each time period
 cron_string <- paste(
  cron_minutes, cron_hours, cron_days_month, cron_months, cron_days_week
 )

 # Copy the string to the user's clipboard if requested
 if (clip) {
  clipr::write_clip(cron_string, allow_non_interactive = TRUE)
  cat("Copied to clipboard\n")
 }

 # Return the full cron expression
 return(cron_string)

}
