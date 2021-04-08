test_that("empty returns minutely string", {
 expect_equal(r2cron(clip = FALSE), "* * * * *")
})

test_that("minutes are viable", {
 expect_equal(r2cron(minutes = 0:59, clip = FALSE), "* * * * *")
 expect_error(r2cron(minutes = "x", clip = FALSE))
 expect_equal(r2cron(minutes = 1, clip = FALSE), "1 * * * *")
 expect_error(r2cron(minutes = 1.2, clip = FALSE))
 expect_error(r2cron(minutes = 60, clip = FALSE))
 expect_equal(r2cron(minutes = 1:3, clip = FALSE), "1-3 * * * *")
 expect_equal(r2cron(minutes = seq(0, 59, 15), clip = FALSE), "0/15 * * * *")
 expect_equal(r2cron(minutes = c(1, 6, 20), clip = FALSE), "1,6,20 * * * *")
})

test_that("hours are viable", {
 expect_equal(r2cron(hours = 0:23, clip = FALSE), "* * * * *")
 expect_error(r2cron(hours = "x", clip = FALSE))
 expect_equal(r2cron(hours = 1, clip = FALSE), "* 1 * * *")
 expect_error(r2cron(hours = 1.2, clip = FALSE))
 expect_error(r2cron(hours = 24, clip = FALSE))
 expect_equal(r2cron(hours = 1:3, clip = FALSE), "* 1-3 * * *")
 expect_equal(r2cron(hours = seq(0, 23, 3), clip = FALSE), "* 0/3 * * *")
 expect_equal(r2cron(hours = c(1, 6, 20), clip = FALSE), "* 1,6,20 * * *")
})

test_that("days_month are viable", {
 expect_equal(r2cron(days_month = 1:31, clip = FALSE), "* * * * *")
 expect_error(r2cron(days_month = "x", clip = FALSE))
 expect_equal(r2cron(days_month = 1, clip = FALSE), "* * 1 * *")
 expect_error(r2cron(days_month = 1.2, clip = FALSE))
 expect_error(r2cron(days_month = 32, clip = FALSE))
 expect_equal(r2cron(days_month = 1:3, clip = FALSE), "* * 1-3 * *")
 expect_equal(r2cron(days_month = seq(1, 31, 3), clip = FALSE), "* * 1/3 * *")
 expect_equal(r2cron(days_month = c(1, 6, 20), clip = FALSE), "* * 1,6,20 * *")
})

test_that("months are viable", {
 expect_equal(r2cron(months = 1:12, clip = FALSE), "* * * * *")
 expect_error(r2cron(months = "x", clip = FALSE))
 expect_equal(r2cron(months = 1, clip = FALSE), "* * * 1 *")
 expect_error(r2cron(months = 1.2, clip = FALSE))
 expect_error(r2cron(months = 13, clip = FALSE))
 expect_equal(r2cron(months = 1:3, clip = FALSE), "* * * 1-3 *")
 expect_equal(r2cron(months = seq(1, 12, 3), clip = FALSE), "* * * 1/3 *")
 expect_equal(r2cron(months = c(1, 6, 7), clip = FALSE), "* * * 1,6,7 *")
})

test_that("days_week are viable", {
 expect_equal(r2cron(days_week = 1:7, clip = FALSE), "* * * * *")
 expect_error(r2cron(days_week = "x", clip = FALSE))
 expect_equal(r2cron(days_week = 2, clip = FALSE), "* * * * 1")
 expect_error(r2cron(days_week = 1.2, clip = FALSE))
 expect_error(r2cron(days_week = 8, clip = FALSE))
 expect_equal(r2cron(days_week = 2:4, clip = FALSE), "* * * * 1-3")
 expect_equal(r2cron(days_week = seq(1, 7, 2), clip = FALSE), "* * * * 0/2")
 expect_equal(r2cron(days_week = c(1, 3, 4), clip = FALSE), "* * * * 0,2,3")
})

test_that("out-of-range values are warned", {
 expect_warning(r2cron(days_month = 29, months = 2, clip = FALSE))
 expect_warning(r2cron(days_month = 30, months = 2, clip = FALSE))
 expect_warning(r2cron(days_month = 31, months = 2, clip = FALSE))
 expect_warning(r2cron(days_month = 31, months = 4, clip = FALSE))
 expect_warning(r2cron(days_month = 31, months = 6, clip = FALSE))
 expect_warning(r2cron(days_month = 31, months = 9, clip = FALSE))
 expect_warning(r2cron(days_month = 31, months = 11, clip = FALSE))
 expect_warning(r2cron(days_month = 29, months = 1:2, clip = FALSE))
 expect_warning(r2cron(days_month = 31, months = c(1, 4), clip = FALSE))
})

test_that("clipboard-copying is supported", {
  msg <- "Copied to clipboard"
  skip_on_os("linux")  # R CMD check fails on Ubuntu because {clipr}
  expect_output(r2cron(), msg)
  expect_output(r2cron(clip = TRUE), msg)
  expect_output(r2cron(minutes = 1, clip = TRUE), msg)
})
