test_that("empty returns minutely string", {
 expect_equal(r2cron(clip = FALSE), "* * * * *")
})

test_that("minutes are viable", {
 expect_equal(r2cron(minutes = "*", clip = FALSE), "* * * * *")
 expect_error(r2cron(minutes = "x", clip = FALSE))
 expect_equal(r2cron(minutes = 1, clip = FALSE), "1 * * * *")
 expect_error(r2cron(minutes = 60, clip = FALSE))
 expect_equal(r2cron(minutes = 1:3, clip = FALSE), "1-3 * * * *")
 expect_equal(r2cron(minutes = seq(0, 59, 15), clip = FALSE), "0/15 * * * *")
 expect_equal(r2cron(minutes = c(1, 6, 20), clip = FALSE), "1,6,20 * * * *")
})

test_that("hours are viable", {
 expect_equal(r2cron(hours = "*", clip = FALSE), "* * * * *")
 expect_error(r2cron(hours = "x", clip = FALSE))
 expect_equal(r2cron(hours = 1, clip = FALSE), "* 1 * * *")
 expect_error(r2cron(hours = 24, clip = FALSE))
 expect_equal(r2cron(hours = 1:3, clip = FALSE), "* 1-3 * * *")
 expect_equal(r2cron(hours = seq(0, 23, 3), clip = FALSE), "* 0/3 * * *")
 expect_equal(r2cron(hours = c(1, 6, 20), clip = FALSE), "* 1,6,20 * * *")
})

test_that("days_month are viable", {
 expect_equal(r2cron(days_month = "*", clip = FALSE), "* * * * *")
 expect_error(r2cron(days_month = "x", clip = FALSE))
 expect_equal(r2cron(days_month = 1, clip = FALSE), "* * 1 * *")
 expect_error(r2cron(days_month = 32, clip = FALSE))
 expect_equal(r2cron(days_month = 1:3, clip = FALSE), "* * 1-3 * *")
 expect_equal(r2cron(days_month = seq(1, 31, 3), clip = FALSE), "* * 1/3 * *")
 expect_equal(r2cron(days_month = c(1, 6, 20), clip = FALSE), "* * 1,6,20 * *")
})

test_that("months are viable", {
 expect_equal(r2cron(months = "*", clip = FALSE), "* * * * *")
 expect_error(r2cron(months = "x", clip = FALSE))
 expect_equal(r2cron(months = 1, clip = FALSE), "* * * 1 *")
 expect_error(r2cron(months = 13, clip = FALSE))
 expect_equal(r2cron(months = 1:3, clip = FALSE), "* * * 1-3 *")
 expect_equal(r2cron(months = seq(1, 12, 3), clip = FALSE), "* * * 1/3 *")
 expect_equal(r2cron(months = c(1, 6, 7), clip = FALSE), "* * * 1,6,7 *")
})

test_that("days_week are viable", {
 expect_equal(r2cron(days_week = "*", clip = FALSE), "* * * * *")
 expect_error(r2cron(days_week = "x", clip = FALSE))
 expect_equal(r2cron(days_week = 1, clip = FALSE), "* * * * 1")
 expect_error(r2cron(days_week = 7, clip = FALSE))
 expect_equal(r2cron(days_week = 1:3, clip = FALSE), "* * * * 1-3")
 expect_equal(r2cron(days_week = seq(0, 6, 2), clip = FALSE), "* * * * 0/2")
 expect_equal(r2cron(days_week = c(1, 5, 6), clip = FALSE), "* * * * 1,5,6")
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
