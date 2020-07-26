
<!-- README.md is generated from README.Rmd. Please edit that file -->

# monashtipr

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/jimmyday12/monash_tipr/branch/master/graph/badge.svg)](https://codecov.io/gh/jimmyday12/monash_tipr?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/jimmyday12/monash_tipr/workflows/R-CMD-check/badge.svg)](https://github.com/jimmyday12/monash_tipr/actions)
<!-- badges: end -->

The goal of monashtipr is to provide an API to the Monash AFL Tipping
competition.

## Installation

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jimmyday12/monash_tipr")
#> Using github PAT from envvar GITHUB_PAT
#> Skipping install of 'monashtipr' from a github remote, the SHA1 (d25eb7b5) has not changed since last install.
#>   Use `force = TRUE` to force installation
```

## Workflow

The two main functions are `get_games()` and `submit_tips`. The general
workflow is to use `get_games()` to grab a data frame of the games from
a particular round, edit/add your tips and then submit them to the
Monash website using `submit_tips`.

First we pull down the games. I’ve chosen to store my password and
username in an Renviron file here to keep them secret, but you could
pass these in via plain text. Read up on options for this
[here](https://cran.r-project.org/web/packages/httr/vignettes/secrets.html)

``` r
library(monashtipr)

# Store password and username
# If wanted - store user/password in Renviron file
# e.g. you can run `usethis::edit_r_environ()` and edit them
# MONASH_USER = xxx
# MONASH_PASS = xxx

user <- Sys.getenv("MONASH_USER")
pass =  Sys.getenv("MONASH_PASS")
```

Now we can pull games.

``` r
comp = "normal"
games <- get_games(user, pass, comp = comp)
#> Login succesfull!
#> Returning current rounds games below...

games
#>   Game           Ground       Home        Away Margin
#> 1    1 Metricon Stadium Gold_Coast  W_Bulldogs     NA
#> 2    2   GIANTS Stadium G_W_Sydney    Richmond     NA
#> 3    3            Gabba  Kangaroos     Carlton     NA
#> 4    4              SCG     Sydney    Hawthorn     NA
#> 5    5    Adelaide Oval P_Adelaide    St_Kilda     NA
#> 6    6    Adelaide Oval   Adelaide    Essendon     NA
#> 7    7    Optus Stadium    W_Coast Collingwood     NA
#> 8    8 Metricon Stadium  Melbourne    Brisbane     NA
#> 9    9    Optus Stadium  Fremantle     Geelong     NA
```

Next - we edit the games data frame to add our tips. How you do this
will vary by how you actually store your tips - you might do a join with
your existing model output for example. I’ll leave that up to the user.
A simple example would be to provide a vector of margins.

Please note - these should always be the margin tip of the HOME TEAM.

``` r
games$Margin <- c(1, 6, 4, 4, 20, -1, -2, -12, -7)
games
#>   Game           Ground       Home        Away Margin
#> 1    1 Metricon Stadium Gold_Coast  W_Bulldogs      1
#> 2    2   GIANTS Stadium G_W_Sydney    Richmond      6
#> 3    3            Gabba  Kangaroos     Carlton      4
#> 4    4              SCG     Sydney    Hawthorn      4
#> 5    5    Adelaide Oval P_Adelaide    St_Kilda     20
#> 6    6    Adelaide Oval   Adelaide    Essendon     -1
#> 7    7    Optus Stadium    W_Coast Collingwood     -2
#> 8    8 Metricon Stadium  Melbourne    Brisbane    -12
#> 9    9    Optus Stadium  Fremantle     Geelong     -7
```

Now we just pass this back with our original credentials and we are good
to go\! =

``` r
submit_tips(games, user, pass, comp = comp)
#> Login succesfull!
#> Submitting with '.submit'
#>   Game       Team Margin              Status
#> 1    1 Gold_Coast      1 Too late! (skipped)
#> 2    2 G_W_Sydney      6 Too late! (skipped)
#> 3    3  Kangaroos      4 Too late! (skipped)
#> 4    4     Sydney      4 Too late! (skipped)
#> 5    5 P_Adelaide     20 Too late! (skipped)
#> 6    6   Adelaide      1 Too late! (skipped)
#> 7    7    W_Coast      2 Too late! (skipped)
#> 8    8  Melbourne     12 Too late! (skipped)
#> 9    9  Fremantle      7            Updated.
```
