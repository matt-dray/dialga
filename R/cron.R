#' Build Cron Strings from R Expressions
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
#' @param clip Logical. Copy output to clipboard? Windows, macOS and X11 only.
#'     Requires installation of the {clipr} package.
#'
#' @details The time-period arguments default to every unit within that time
#'     period, like 'every minute, of every hour, of every day of the month,
#'     etc'. The following input formats are acceptable inputs to all the time
#'     period arguments:
#' \itemize{
#'   \item a single integer value, like \code{1}
#'   \item consecutive-integer vectors, like \code{1:3}
#'   \item nonconsecutive, irregularly-spaced integer vectors, like
#'       \code{c(2, 3, 5)}
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
#' @examples \dontrun{
#' r2cron(
#'   minutes = seq(0, 59, 20),
#'   hours = 15:17,  # 24-hr clock
#'   days_month = 1,
#'   months = c(4, 10, 11),
#'   days_week = c(1, 7),  # Sunday is '1'
#'   clip = FALSE
#' )}
#'
r2cron <- function(minutes = 0L:59L, hours  = 0L:23L,
                   days_month  = 1L:31L, months = 1L:12L, days_week  = 1L:7L,
                   clip = FALSE) {

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

#' Generate English Interpretation of Valid Cron Strings
#'
#' Demystify the meaning of a valid cron string by converting it to an
#' equivalent sentence in English. Can take the output from \code{\link{r2cron}}
#' for example. (Under development.)
#'
#' @param cron Character. A valid cron expression, i.e. a string with five
#'     time period 'slots' (minutes, hours, days of the month, months, days of
#'     the week), separated by spaces. See details for more information.
#'
#' @details The cron string slots and their valid ranges are:
#' \itemize{
#'   \item Slot 1: minutes past the hour, integers 0 to 59 inclusive.
#'   \item Slot 2: hours on a 24-hour clock, integers 0 to 23 inclusive.
#'   \item Slot 3: day number of the month, integers 1 to 31 inclusive.
#'   \item Slot 4: month number, integers 1 to 12 inclusive.
#'   \item Slot 5: day of the week, integers 0 to 6 inclusive (where Sunday is
#'     the first day of the week).
#' }
#'
#' In addition, the following input formats are acceptable to all the time
#' slots:
#' \itemize{
#'   \item a single integer value, like \code{1}
#'   \item consecutive-integer vectors, like \code{1:3}
#'   \item nonconsecutive, irregularly-spaced integer vectors, like
#'       \code{c(2, 3, 5)}
#'   \item regularly-spaced integer sequences with specified start and end
#'       values, like \code{seq(3, 59, 15)} (useful for specifying
#'       sequences within the full time period,'every 15 minutes of the
#'       hour starting from minute 3', like in this example)
#' }
#'
#' @return Result printed to console. An English sentence interpretation of the
#'     cron string that was the input.
#' @export
#'
#' @examples \dontrun{
#' cron2eng("1,2,5 2-3 * 1/3 5")}
#'
cron2eng <- function(cron = "* * * * *") {

  if (!is.character(cron)) {
    stop("Argument 'cron' must be a valid character-class cron expression.")
  }

  if (length(strsplit(cron, " ")[[1]]) != 5) {
    stop("Argument 'cron' must be a valid cron expression.")
  }

  if (length(strsplit(cron, " ")[[1]]) != 5 |  # 5 time slots
      !all(grepl("\\d|\\*|\\s|,|/|-", strsplit(cron, "")[[1]])) |  # valid chars
      !all(grepl("\\b[0-9]\\b|\\b[1-5][0-9]\\b|\\*",
                 strsplit(cron, "\\s|,|/|-")[[1]])) ) {  # valid number range
    stop(
      "Argument 'cron' must have five 'time slots' separated by spaces.\n",
      "Slots must contain valid integers or '*', '/', '-' and ',."
    )
  }

  # Split each time period to a list element
  p_list <- as.list(strsplit(cron, " ")[[1]])

  # Name elements with text to be used in output for that time period
  names(p_list) <- c(
    "minute(s)", "hour(s)", "day(s) of the month",
    "month(s)", "day(s) of the week"
  )

  if (grepl("\\d", p_list[[2]])) {

    if (grepl("/", p_list[[2]])) {

      p_list[[2]] <- gsub("^0(?=/)",  "12AM", p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^1(?=/)",  "1AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^2(?=/)",  "2AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^3(?=/)",  "3AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^4(?=/)",  "4AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^5(?=/)",  "5AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^6(?=/)",  "6AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^7(?=/)",  "7AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^8(?=/)",  "8AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^9(?=/)",  "9AM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^10(?=/)", "10AM", p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^11(?=/)", "11AM", p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^12(?=/)", "12PM", p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^13(?=/)", "1PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^14(?=/)", "2PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^15(?=/)", "3PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^16(?=/)", "4PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^17(?=/)", "5PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^18(?=/)", "6PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^19(?=/)", "7PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^20(?=/)", "8PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^21(?=/)", "9PM",  p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^22(?=/)", "10PM", p_list[[2]], perl = TRUE)
      p_list[[2]] <- gsub("^23(?=/)", "11PM", p_list[[2]], perl = TRUE)

    } else {

      p_list[[2]] <- gsub("\\b0\\b",  "12AM", p_list[[2]])
      p_list[[2]] <- gsub("\\b1\\b",  "1AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b2\\b",  "2AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b3\\b",  "3AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b4\\b",  "4AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b5\\b",  "5AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b6\\b",  "6AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b7\\b",  "7AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b8\\b",  "8AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b9\\b",  "9AM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b10\\b", "10AM", p_list[[2]])
      p_list[[2]] <- gsub("\\b11\\b", "11AM", p_list[[2]])
      p_list[[2]] <- gsub("\\b12\\b", "12PM", p_list[[2]])
      p_list[[2]] <- gsub("\\b13\\b", "1PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b14\\b", "2PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b15\\b", "3PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b16\\b", "4PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b17\\b", "5PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b18\\b", "6PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b19\\b", "7PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b20\\b", "8PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b21\\b", "9PM",  p_list[[2]])
      p_list[[2]] <- gsub("\\b22\\b", "10PM", p_list[[2]])
      p_list[[2]] <- gsub("\\b23\\b", "11PM", p_list[[2]])

    }

  }

  if (grepl("\\d", p_list[[4]])) {

    if (grepl("/", p_list[[4]])) {

      p_list[[4]] <- gsub("^1(?=/)",  "January",   p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^2(?=/)",  "February",  p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^3(?=/)",  "March",     p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^4(?=/)",  "April",     p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^5(?=/)",  "May",       p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^6(?=/)",  "June",      p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^7(?=/)",  "July",      p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^8(?=/)",  "August",    p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^9(?=/)",  "September", p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^10(?=/)", "October",   p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^11(?=/)", "November",  p_list[[4]], perl = TRUE)
      p_list[[4]] <- gsub("^12(?=/)", "December",  p_list[[4]], perl = TRUE)

    } else {

      p_list[[4]] <- gsub("\\b1\\b",  "January",   p_list[[4]])
      p_list[[4]] <- gsub("\\b2\\b",  "February",  p_list[[4]])
      p_list[[4]] <- gsub("\\b3\\b",  "March",     p_list[[4]])
      p_list[[4]] <- gsub("\\b4\\b",  "April",     p_list[[4]])
      p_list[[4]] <- gsub("\\b5\\b",  "May",       p_list[[4]])
      p_list[[4]] <- gsub("\\b6\\b",  "June",      p_list[[4]])
      p_list[[4]] <- gsub("\\b7\\b",  "July",      p_list[[4]])
      p_list[[4]] <- gsub("\\b8\\b",  "August",    p_list[[4]])
      p_list[[4]] <- gsub("\\b9\\b",  "September", p_list[[4]])
      p_list[[4]] <- gsub("\\b10\\b", "October",   p_list[[4]])
      p_list[[4]] <- gsub("\\b11\\b", "November",  p_list[[4]])
      p_list[[4]] <- gsub("\\b12\\b", "December",  p_list[[4]])

    }

  }

  if (grepl("\\d", p_list[[5]])) {

    if (grepl("/", p_list[[5]])) {

      p_list[[5]] <- gsub("0(?=/)", "Sunday",    p_list[[5]], perl = TRUE)
      p_list[[5]] <- gsub("1(?=/)", "Monday",    p_list[[5]], perl = TRUE)
      p_list[[5]] <- gsub("2(?=/)", "Tuesday",   p_list[[5]], perl = TRUE)
      p_list[[5]] <- gsub("3(?=/)", "Wednesday", p_list[[5]], perl = TRUE)
      p_list[[5]] <- gsub("4(?=/)", "Thursday",  p_list[[5]], perl = TRUE)
      p_list[[5]] <- gsub("5(?=/)", "Friday",    p_list[[5]], perl = TRUE)
      p_list[[5]] <- gsub("6(?=/)", "Saturday",  p_list[[5]], perl = TRUE)

    } else {

      p_list[[5]] <- gsub("0", "Sunday",    p_list[[5]])
      p_list[[5]] <- gsub("1", "Monday",    p_list[[5]])
      p_list[[5]] <- gsub("2", "Tuesday",   p_list[[5]])
      p_list[[5]] <- gsub("3", "Wednesday", p_list[[5]])
      p_list[[5]] <- gsub("4", "Thursday",  p_list[[5]])
      p_list[[5]] <- gsub("5", "Friday",    p_list[[5]])
      p_list[[5]] <- gsub("6", "Saturday",  p_list[[5]])

    }

  }

  # Convert each time period's cron expression to English
  for (p in names(p_list)) {

    if (p_list[[p]] == "*") {

      # Every valid unit of the time period
      if (p == names(p_list)[5]) {
        p_list[[p]] <- paste("any", p)  # more specific for day of week
      } else {
        p_list[[p]] <- paste("every", p)
      }

    } else if (grepl("^\\d{1,2}$|^\\w{1,}$", p_list[[p]])) {

      # Single integer value
      p_list[[p]] <- paste(p, p_list[[p]])

    } else if (grepl("^\\w{1,}-\\w{1,}$", p_list[[p]])) {

      # Consecutive units with non-min start and non-max stop value
      n_split <- strsplit(p_list[[p]], "-")
      p_list[[p]] <- paste(
        p, n_split[[1]][1], "to", n_split[[1]][2]
      )

    } else if (grepl("^\\w{1,},", p_list[[p]])) {

      # Nonconsecutive, irregularly spaced integers
      n_units <- strsplit(p_list[[p]], ",")[[1]]
      p_list[[p]] <- paste(p, .vec2eng(n_units))

    } else if (grepl("^\\w{1,}/\\w{1,}$", p_list[[p]])) {

      # regularly-spaced integer sequences with specified start and end
      n_split <- strsplit(p_list[[p]], "/")
      p_list[[p]] <- paste0(
        "every ", n_split[[1]][2], " ", p,
        " starting from ",
        ifelse(p %in% c("minute(s)", "day(s)"), paste0(p, " "), ""),
        n_split[[1]][1]
      )

    }

  }

  # Collate sentences for each time period
  cat(
    paste0("Cron string '", cron, "' means:"),
    paste0("  - ", p_list[[1]]),
    paste0("  - ", p_list[[2]]),
    paste0("  - ", p_list[[3]]),
    paste0("  - ", p_list[[4]]),
    ifelse(  # a clear 'and' for user-specified days of the week
      grepl("^day", p_list[[5]]),
      paste0("  - and ", p_list[[5]]),
      paste0("  - ", p_list[[5]])
    ),
    sep = "\n"
  )

}
