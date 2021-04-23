
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="https://raw.githubusercontent.com/matt-dray/stickers/master/output/dialga_hex.png" width="150" align="right">

# {dialga}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/dialga/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/dialga/actions)
[![Codecov test
coverage](https://codecov.io/gh/matt-dray/dialga/branch/main/graph/badge.svg)](https://codecov.io/gh/matt-dray/dialga?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/matt-dray/dialga/badge)](https://www.codefactor.io/repository/github/matt-dray/dialga)
[![rostrum.blog
post](https://img.shields.io/badge/rostrum.blog-post-008900?style=flat&labelColor=black&logo=data:image/gif;base64,R0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh+QQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/2021/04/10/dialga/)
<!-- badges: end -->

## Purpose

{dialga} is an R package that lets you build and interpret standard
[cron expressions](https://en.wikipedia.org/wiki/Cron#CRON_expression)
using familiar R syntax.

Cron is software for scheduling computer tasks (‘cron jobs’). Cron
strings detail concisely the required schedule. They require a specific
format, like `"0/15 * 1,3,20 6 0,6"`, but it can be difficult to
remember how to structure them.

Under development. Just for fun. Bugs likely. Read more in [the
accompanying blog post](https://www.rostrum.blog/2021/04/10/dialga/).

## Install

Install from GitHub with help from {remotes}:

``` r
install.packages("remotes")  # if not already installed
remotes::install_github("matt-dray/dialga")
library(dialga)
```

## Demonstration

There’s currently two functions: `r2cron()` takes integer vectors as
inputs to time-period arguments and spits out a cron string, and
`cron2eng()` takes a valid cron string and prints out a readable English
version. See `?dialga::r2cron()` and `?dialga::cron2eng()` for further
details.

### Simple

A simple example of `r2cron()`: how would you specify the 28th minute
past 11PM every day?

``` r
x <- dialga::r2cron(
  minutes = 28, 
  hours = 23  # 24-hour clock
)

x
#> [1] "28 23 * * *"
```

Note that you can use the argument `clip = TRUE` to copy the output to
your clipboard so you can paste it elsewhere.

To interpret the output—and confirm we got what we expected—we can pass
that cron string into `cron2eng()`.

``` r
dialga::cron2eng(x)
#> Cron string '28 23 * * *' means:
#>   - minute(s) 28
#>   - hour(s) 11PM
#>   - every day(s) of the month
#>   - every month(s)
#>   - any day(s) of the week
```

The output isn’t sophisticated, but it communicates the point.

You could even pipe these functions together to go from R to English.

``` r
library(magrittr)  # for %>%

dialga::r2cron(minutes = 28, hours = 23) %>% 
  dialga::cron2eng()
#> Cron string '28 23 * * *' means:
#>   - minute(s) 28
#>   - hour(s) 11PM
#>   - every day(s) of the month
#>   - every month(s)
#>   - any day(s) of the week
```

### Complex

A more complicated (i.e. contrived) request might be ‘every 20 minutes
from the zeroth minute of 3PM, 4PM and 5PM, on the 1st days of April,
October and November, plus every weekend’:

``` r
y <- dialga::r2cron(
 minutes = seq(0, 59, 20),
 hours = 15:17,  # 24-hr clock
 days_month = 1,
 months = c(4, 10, 11),
 days_week = c(1, 7)  # Sunday is '1'
)

y
#> [1] "0/20 15-17 1 4,10,11 0,6"
```

And in English:

``` r
dialga::cron2eng(y)
#> Cron string '0/20 15-17 1 4,10,11 0,6' means:
#>   - every 20 minute(s) starting from minute(s) 0
#>   - hour(s) 3PM to 5PM
#>   - day(s) of the month 1
#>   - month(s) April, October and November
#>   - and day(s) of the week Sunday and Saturday
```

### Warnings

As a courtesy, you’ll be warned when unlikely dates arise:

``` r
dialga::r2cron(days_month = 28:31, months = 2)
#> Warning in dialga::r2cron(days_month = 28:31, months = 2): 
#>   Sure? There's no 31st in Feb, Apr, Jun, Sept nor Nov.
#> Warning in dialga::r2cron(days_month = 28:31, months = 2): 
#>   Sure? There's no 30th in Feb.
#> Warning in dialga::r2cron(days_month = 28:31, months = 2): 
#>   Sure? 29 Feb is only in leap years.
#> [1] "* * 28-31 2 *"
```

## Actual scheduling tools

If on Unix/Linux, you can use [the {cronR}
package](https://github.com/bnosac/cronR) to schedule tasks from R. The
Windows alternative is [the {taskscheduleR}
package](https://github.com/bnosac/taskscheduleR). I typically use the
web service [crontab.guru](https://crontab.guru) to build cron
expressions. It was helpful for checking {dialga}’s functionality.

## Code of Conduct

Please note that the {dialga} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
