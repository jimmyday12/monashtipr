
<!-- README.md is generated from README.Rmd. Please edit that file -->

# monashtipr

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/monashtipr)](https://CRAN.R-project.org/package=monashtipr)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/monashtipr)](https://www.r-pkg.org/pkg/monashtipr)
[![CRAN RStudio total
downloads](https://cranlogs.r-pkg.org/badges/grand-total/monashtipr)](https://www.r-pkg.org/pkg/monashtipr)
[![R-CMD-check](https://github.com/jimmyday12/monashtipr/workflows/R-CMD-check/badge.svg)](https://github.com/jimmyday12/monashtipr/actions)
[![Codecov test
coverage](https://codecov.io/gh/jimmyday12/monash_tipr/branch/master/graph/badge.svg)](https://codecov.io/gh/jimmyday12/monash_tipr?branch=master)
[![R-CMD-check](https://github.com/jimmyday12/monashtipr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jimmyday12/monashtipr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `monashtipr` is to provide an R based API that allows users
to submit tips to the [Monash University Probabilistic Footy Tipping
Competition](https://probabilistic-footy.monash.edu/~footy/) from R.

## Installation

Install the released version of `monashtipr` from CRAN:

``` r
install.packages("monashtipr")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jimmyday12/monashtipr")
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
games
```

    #> # A tibble: 9 × 5
    #>    Game Ground                Home        Away       Margin
    #>   <dbl> <chr>                 <chr>       <chr>      <lgl> 
    #> 1     1 MCG                   Carlton     Richmond   NA    
    #> 2     2 MCG                   Collingwood Sydney     NA    
    #> 3     3 MCG                   Essendon    Hawthorn   NA    
    #> 4     4 GIANTS Stadium        G_W_Sydney  Kangaroos  NA    
    #> 5     5 GMHBA Stadium         Geelong     St_Kilda   NA    
    #> 6     6 Heritage Bank Stadium Gold_Coast  Adelaide   NA    
    #> 7     7 MCG                   Melbourne   W_Bulldogs NA    
    #> 8     8 Adelaide Oval         P_Adelaide  W_Coast    NA    
    #> 9     9 Optus Stadium         Fremantle   Brisbane   NA

Next - we edit the games data frame to add our tips. How you do this
will vary by how you actually store your tips - you might do a join with
your existing model output for example. I’ll leave that up to the user.
A simple example would be to provide a vector of margins.

Please note - these should always be the margin tip of the HOME TEAM.

``` r
games$Margin <- c(1, 6, 4, 4, 20, -1, -2, -12, -7)
games
#> # A tibble: 9 × 5
#>    Game Ground                Home        Away       Margin
#>   <dbl> <chr>                 <chr>       <chr>       <dbl>
#> 1     1 MCG                   Carlton     Richmond        1
#> 2     2 MCG                   Collingwood Sydney          6
#> 3     3 MCG                   Essendon    Hawthorn        4
#> 4     4 GIANTS Stadium        G_W_Sydney  Kangaroos       4
#> 5     5 GMHBA Stadium         Geelong     St_Kilda       20
#> 6     6 Heritage Bank Stadium Gold_Coast  Adelaide       -1
#> 7     7 MCG                   Melbourne   W_Bulldogs     -2
#> 8     8 Adelaide Oval         P_Adelaide  W_Coast       -12
#> 9     9 Optus Stadium         Fremantle   Brisbane       -7
```

Now we just pass this back with our original credentials and we are good
to go!

``` r
submit_tips(games, user, pass, comp = comp)
```

## Code of Conduct

Please note that the monashtipr project is released with a [Contributor
Code of
Conduct](https://jimmyday12.github.io/monash_tipr/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
