
# r2cron() ----------------------------------------------------------------


test_that("empty r2cron() returns all-asterisk string", {
  expect_equal(r2cron(clip = FALSE), "* * * * *")
  expect_length(r2cron(clip = FALSE), 1)
})

test_that("r2cron() minutes argument works", {

 expect_equal(r2cron(minutes = 0:59, clip = FALSE), "* * * * *")
 expect_equal(r2cron(minutes = 1, clip = FALSE), "1 * * * *")
 expect_equal(r2cron(minutes = 1:3, clip = FALSE), "1-3 * * * *")
 expect_equal(r2cron(minutes = 1:2, clip = FALSE), "1-2 * * * *")
 expect_equal(r2cron(minutes = seq(0, 59, 15), clip = FALSE), "0/15 * * * *")
 expect_equal(r2cron(minutes = c(1, 6), clip = FALSE), "1,6 * * * *")
 expect_equal(r2cron(minutes = c(1, 6, 20), clip = FALSE), "1,6,20 * * * *")

 expect_error(r2cron(minutes = "x", clip = FALSE))
 expect_error(r2cron(minutes = TRUE, clip = FALSE))
 expect_error(r2cron(minutes = mtcars, clip = FALSE))
 expect_error(r2cron(minutes = list("x", "y"), clip = FALSE))
 expect_error(r2cron(minutes = 1.2, clip = FALSE))
 expect_error(r2cron(minutes = 60, clip = FALSE))

})

test_that("r2cron() hours argument works", {

 expect_equal(r2cron(hours = 0:23, clip = FALSE), "* * * * *")
 expect_equal(r2cron(hours = 1, clip = FALSE), "* 1 * * *")
 expect_equal(r2cron(hours = 1:3, clip = FALSE), "* 1-3 * * *")
 expect_equal(r2cron(hours = 1:2, clip = FALSE), "* 1-2 * * *")
 expect_equal(r2cron(hours = seq(0, 23, 3), clip = FALSE), "* 0/3 * * *")
 expect_equal(r2cron(hours = c(1, 6), clip = FALSE), "* 1,6 * * *")
 expect_equal(r2cron(hours = c(1, 6, 20), clip = FALSE), "* 1,6,20 * * *")

 expect_error(r2cron(hours = "x", clip = FALSE))
 expect_error(r2cron(hours = TRUE, clip = FALSE))
 expect_error(r2cron(hours = mtcars, clip = FALSE))
 expect_error(r2cron(hours = list("x", "y"), clip = FALSE))
 expect_error(r2cron(hours = 1.2, clip = FALSE))
 expect_error(r2cron(hours = 24, clip = FALSE))

})

test_that("r2cron() days_month argument works", {

 expect_equal(r2cron(days_month = 1:31, clip = FALSE), "* * * * *")
 expect_equal(r2cron(days_month = 1, clip = FALSE), "* * 1 * *")
 expect_equal(r2cron(days_month = 1:3, clip = FALSE), "* * 1-3 * *")
 expect_equal(r2cron(days_month = 1:2, clip = FALSE), "* * 1-2 * *")
 expect_equal(r2cron(days_month = seq(1, 31, 3), clip = FALSE), "* * 1/3 * *")
 expect_equal(r2cron(days_month = c(1, 6), clip = FALSE), "* * 1,6 * *")
 expect_equal(r2cron(days_month = c(1, 6, 20), clip = FALSE), "* * 1,6,20 * *")

 expect_error(r2cron(days_month = "x", clip = FALSE))
 expect_error(r2cron(days_month = TRUE, clip = FALSE))
 expect_error(r2cron(days_month = mtcars, clip = FALSE))
 expect_error(r2cron(days_month = list("x", "y"), clip = FALSE))
 expect_error(r2cron(days_month = 1.2, clip = FALSE))
 expect_error(r2cron(days_month = 32, clip = FALSE))

})

test_that("r2cron() months argument works", {

 expect_equal(r2cron(months = 1:12, clip = FALSE), "* * * * *")
 expect_equal(r2cron(months = 1, clip = FALSE), "* * * 1 *")
 expect_equal(r2cron(months = 1:3, clip = FALSE), "* * * 1-3 *")
 expect_equal(r2cron(months = 1:2, clip = FALSE), "* * * 1-2 *")
 expect_equal(r2cron(months = seq(1, 12, 3), clip = FALSE), "* * * 1/3 *")
 expect_equal(r2cron(months = c(1, 6), clip = FALSE), "* * * 1,6 *")
 expect_equal(r2cron(months = c(1, 6, 7), clip = FALSE), "* * * 1,6,7 *")

 expect_error(r2cron(months = "x", clip = FALSE))
 expect_error(r2cron(months = TRUE, clip = FALSE))
 expect_error(r2cron(months = mtcars, clip = FALSE))
 expect_error(r2cron(months = list("x", "y"), clip = FALSE))
 expect_error(r2cron(months = 1.2, clip = FALSE))
 expect_error(r2cron(months = 13, clip = FALSE))

})

test_that("r2cron() days_week argument works", {

 expect_equal(r2cron(days_week = 1:7, clip = FALSE), "* * * * *")
 expect_equal(r2cron(days_week = 2, clip = FALSE), "* * * * 1")
 expect_equal(r2cron(days_week = 2:4, clip = FALSE), "* * * * 1-3")
 expect_equal(r2cron(days_week = 2:3, clip = FALSE), "* * * * 1-2")
 expect_equal(r2cron(days_week = seq(1, 7, 2), clip = FALSE), "* * * * 0/2")
 expect_equal(r2cron(days_week = c(1, 3), clip = FALSE), "* * * * 0,2")
 expect_equal(r2cron(days_week = c(1, 7), clip = FALSE), "* * * * 0,6")
 expect_equal(r2cron(days_week = c(1, 3, 4), clip = FALSE), "* * * * 0,2,3")

 expect_error(r2cron(days_week = "x", clip = FALSE))
 expect_error(r2cron(days_week = TRUE, clip = FALSE))
 expect_error(r2cron(days_week = mtcars, clip = FALSE))
 expect_error(r2cron(days_week = list("x", "y"), clip = FALSE))
 expect_error(r2cron(days_week = 1.2, clip = FALSE))
 expect_error(r2cron(days_week = 8, clip = FALSE))

})

test_that("r2cron() out-of-range day-month values are warned", {

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

test_that("r2cron() clipboard-copying is supported", {

  msg <- "Copied to clipboard"
  skip_on_os("linux")  # R CMD check fails on Ubuntu because {clipr}
  expect_output(r2cron(clip = TRUE), msg)
  expect_output(r2cron(minutes = 1, clip = TRUE), msg)

})


# cron2eng() --------------------------------------------------------------


test_that("cron2eng() errors with bad input", {

  expect_error(cron2eng(1))
  expect_error(cron2eng("x"))
  expect_error(cron2eng("x x x x x"))
  expect_error(cron2eng("* * * *"))
  expect_error(cron2eng(TRUE))
  expect_error(cron2eng(mtcars))
  expect_error(cron2eng(list("x", "y")))

})

test_that("cron2eng() outputs as expected", {

  expect_output(cron2eng())
  expect_output(cron2eng("1-3 1 1,3,4 1 1"))
  expect_output(cron2eng("* 1/5 * 1/3 0/2"))

})

test_that(".vec2eng() does its job", {

  expect_error(dialga:::.vec2eng(iris))
  expect_error(dialga:::.vec2eng(list(x = 1, y = 1)))
  expect_equal(dialga:::.vec2eng(letters[1]), "a")
  expect_equal(dialga:::.vec2eng(letters[1:2]), "a and b")
  expect_equal(dialga:::.vec2eng(letters[1:3]), "a, b and c")

})
