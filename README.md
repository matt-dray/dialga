
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

{dialga} is an R package to help you build standard [cron
expressions](https://en.wikipedia.org/wiki/Cron#CRON_expression) using R
syntax. It might be developed to do other things in future.

This package is a product of
[Pokémon](https://www.pokemon.com/uk/)-Driven Development (PDD). Dialga
is [the ‘temporal
Pokémon’](https://bulbapedia.bulbagarden.net/wiki/Dialga_(Pok%C3%A9mon)).

## Install

Install from GitHub with help from {remotes}:

``` r
install.packages("remotes")  # if not already installed
remotes::install_github("matt-dray/dialga")
```

## Examples

Here are some demos of the `r2cron()` function. By default, the output
will be printed and copied to your clipboard. Turn off copying with the
argument `clip = FALSE`.

Every minute:

``` r
dialga::r2cron(clip = FALSE)
#> [1] "* * * * *"
```

Every 15 minutes starting from the beginning of every hour:

``` r
dialga::r2cron(minutes = seq(0, 59, 15), clip = FALSE)
#> [1] "0/15 * * * *"
```

Every 20 minutes from the the hours starting 1500, 1600 and 1700, on the
1st day of April, October and November, plus every weekend:

``` r
dialga::r2cron(
 minutes = seq(0, 59, 20),
 hours = 15:17,
 days_month = 1,
 months = c(4, 10, 11),
 days_week = c(0, 6),
 clip = FALSE
)
#> [1] "0/20 15-17 1 4,10,11 0,6"
```

Warning for unlikeliness:

``` r
dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE)
#> Warning in dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE): Sure? There's no 31st in Feb, Apr, Jun, Sept nor Nov.
#> Warning in dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE): Sure? There's no 30th in Feb.
#> Warning in dialga::r2cron(days_month = 28:31, months = 2, clip = FALSE): Sure? 29 Feb is only in leap years.
#> [1] "* * 28-31 2 *"
```

## Actual scheduling tools

If on Unix/Linux, you can use [the {cronR}
package](https://github.com/bnosac/cronR) to schedule tasks from R. The
Windows alternative is [the {taskscheduleR}
package](https://github.com/bnosac/taskscheduleR).

I typically use the web service [crontab.guru](https://crontab.guru) to
build cron expressions. It was helpful for checking {dialga}’s
functionality.

## Code of Conduct

Please note that the {dialga} project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
