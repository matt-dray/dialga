# dialga 0.1

* Eliminated {knitr} dependency (#11)
* Make `clip` argument `FALSE` by default in `r2cron()` (#12)
* Eliminated {stringr} dependency (#11)
* Add 'and' to specified day of week for clarity
* Eliminated {stringr} dependency (#11)

# dialga 0.0.0.9002

* Added basic `cron2eng()` function (#5) and improved output format (#10)
* Fixed bug where `days_week = c(1, 7)` was output to `"0/6"` instead of `"0,6"`
* Documented internal functions
* Tested `x/y` edge cases (#9)
* Improved basic test coverage to 100% (#8)

# dialga 0.0.0.9001

* Interpreted `x/y` output format for all time period arguments (#1)
* Changed default inputs to vectors rather than asterisk characters (#2)
* Remove zero-indexing of days of the week (#6)

# dialga 0.0.0.9000

* Added cron.R and utils.R for function `r2cron()`
* Added basic tests for `r2cron()`
* Added package basics, NEWS, COC, license, README
* Added GitHub Actions and badges
