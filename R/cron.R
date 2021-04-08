#' Build A Cron String From R Expressions
#'
#' Provide an R expression to each of the arguments, which are different time
#' periods (minutes, hours, days of the month, months, days of the week), and
#' receive an equivalent cron-expression string in return. See 'arguments' for
#' valid value ranges and 'details' for valid input formats.
#'
#' @param minutes Minutes past the hour, integers 0 to 59 inclusive or asterisk.
#' @param hours Hours on a 24-hour clock, integers 0 to 23 inclusive or
#'     asterisk.
#' @param days_month Day number of the month, integers 1 to 31 inclusive or
#'     asterisk.
#' @param months Month number, integers 1 to 12 inclusive or asterisk.
#' @param days_week Day of the week, integers 0 to 6 inclusive (zero-indexed
#'     starting with Sunday) or asterisk.
#' @param clip Logical. Copy to clipboard?
#'
#' @details The following input formats are acceptable for all the time period
#'     arguments:
#' \itemize{
#'   \item a single asterisk, like \code{"*"}, which is a placeholder character
#'       meaning 'all valid integer values for the given time period' (i.e.
#'       \code{minutes = "*"} means 'every minute')
#'   \item a single numeric value, like \code{1}
#'   \item an integer sequence with increments of 1, like \code{1:3}
#'   \item an integer vector, like \code{c(2, 3, 5)}
#'   \item an equally-spaced sequence of integers with specific start and end
#'       values, like \code{seq(0, 59, 5)}
#' }
#'
#' @return A character string (copied to the clipboard at the user's
#'     discretion).
#' @export
#'
r2cron <- function(minutes = "*", hours  = "*",
                   days_month  = "*", months = "*", days_week  = "*",
                   clip = TRUE) {

 # Stop if input is out of range of time period
 .stop(minutes, "minutes")
 .stop(hours, "hours")
 .stop(days_month, "days_month")
 .stop(months, "months")
 .stop(days_week, "days_week")

 # Warn if month and day combinations seem unlikely
 if (any(months %in% c(2, 4, 6, 9, 11)) & any(days_month == 31)) {
  warning("Sure? There's no 31st in Feb, Apr, Jun, Sept nor Nov.\n")
 }
 if (any(months == 2) & any(days_month == 30)) {
  warning("Sure? There's no 30th in Feb.\n")
 }
 if (any(months == 2) & any(days_month == 29)) {
  warning("Sure? 29 Feb is only in leap years.\n")
 }

 # Convert each argument's R expression to equivalent cron expression
 cron_minutes <- .as_cron(minutes, "minutes")
 cron_hours <- .as_cron(hours, "hours")
 cron_days_month <- .as_cron(days_month, "days_month")
 cron_months <- .as_cron(months, "months")
 cron_days_week <- .as_cron(days_week, "days_week")

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
