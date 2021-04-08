
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dialga

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/dialga/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/dialga/actions)
[![Codecov test
coverage](https://codecov.io/gh/matt-dray/dialga/branch/main/graph/badge.svg)](https://codecov.io/gh/matt-dray/dialga?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/matt-dray/dialga/badge)](https://www.codefactor.io/repository/github/matt-dray/dialga)
<!-- badges: end -->

Under development. Just for fun. Bugs likely.

## Purpose

{dialga} is an R package that (for now) helps you build standard [cron
expressions](https://en.wikipedia.org/wiki/Cron#CRON_expression)—which
are pretty esoteric—using friendly R syntax.

This package is a product of
[Pokémon](https://www.pokemon.com/uk/)-Driven Development (PDD). Dialga
is [the ‘temporal
Pokémon’](https://bulbapedia.bulbagarden.net/wiki/Dialga_(Pok%C3%A9mon)).

## Install

Install from GitHub with help from {remotes}:

``` r
install.packages("remotes")  # if not already installed
remotes::install_github("matt-dray/dialga")
library(dialga)
```

## Demonstration

Below are some demos of the `r2cron()` function. Arguments are named for
each time period in a cron string (minutes, hours, etc) and their inputs
can be in the form of:

-   single integer values, like `1`
-   consecutive-integer vectors, like `1:3`
-   irregularly-spaced integer vectors, like `c(1, 2, 4)`
-   regularly-spaced integer sequences, like `seq(3, 59, 15)` (useful
    for specifying sequences within the full time period, like ‘every 15
    minutes of the hour starting from minute 3’ in this example)

See `?dialga::r2cron()` for further details.

The function defaults to ‘every minute’:

``` r
dialga::r2cron()
#> Copied to clipboard
#> [1] "* * * * *"
```

By default, the output will be printed and copied to your clipboard,
thanks to [the {clipr} package](https://github.com/mdlincoln/clipr).
Turn off copying with the argument `clip = FALSE`.

Here’s ‘every 15 minutes starting from the beginning of every hour’:

``` r
dialga::r2cron(minutes = seq(0, 59, 15), clip = FALSE)
#> [1] "0/15 * * * *"
```

A more complicated (i.e. contrived) request might be ‘every 20 minutes
from the zeroth minute of the hours 1500, 1600 and 1700, on the 1st day
of April, October and November, plus every weekend’:

``` r
dialga::r2cron(
 minutes = seq(0, 59, 20),
 hours = 15:17,  # 24-hr clock
 days_month = 1,
 months = c(4, 10, 11),
 days_week = c(1, 7),  # Sunday is '1'
 clip = FALSE
)
#> [1] "0/20 15-17 1 4,10,11 0/6"
```

As a courtesy, you’ll be warned when unlikely dates arise:

``` r
dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE)
#> Warning in dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE): 
#>   Sure? There's no 31st in Feb, Apr, Jun, Sept nor Nov.
#> Warning in dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE): 
#>   Sure? There's no 30th in Feb.
#> Warning in dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE): 
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
