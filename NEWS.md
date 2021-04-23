# dialga 0.0.0.9003

* Eliminated {knitr} dependency (#11)
* Make `clip` argument `FALSE` by default in `r2cron()` (#12)

# dialga 0.0.0.9002

* Add basic `cron2eng()` function (#5) and improved output format (#10)
* Fixed bug where `days_week = c(1, 7)` was output to `"0/6"` instead of `"0,6"`
* Document internal functions
* Test `x/y` edge cases (#9)
* Basic test coverage to 100% (#8)

# dialga 0.0.0.9001

* `x/y` output format now interpreted for all time period arguments (#1)
* Default inputs are now vectors rather than asterisk character (#2)
* Days of the week no longer zero0indexed (#6)

# dialga 0.0.0.9000

* Added cron.R and utils.R for function `r2cron()`
* Added basic tests for `r2cron()`
* Added package basics, NEWS, COC, license, README
* Added GitHub Actions and badges
