
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
#> # A tibble: 9 x 5
#>    Game Ground         Home        Away       Margin
#>   <int> <chr>          <chr>       <chr>      <lgl> 
#> 1     1 MCG            Richmond    Carlton    NA    
#> 2     2 MCG            Collingwood W_Bulldogs NA    
#> 3     3 MCG            Melbourne   Fremantle  NA    
#> 4     4 Adelaide Oval  Adelaide    Geelong    NA    
#> 5     5 Marvel Stadium Essendon    Hawthorn   NA    
#> 6     6 Gabba          Brisbane    Sydney     NA    
#> 7     7 Marvel Stadium Kangaroos   P_Adelaide NA    
#> 8     8 GIANTS Stadium G_W_Sydney  St_Kilda   NA    
#> 9     9 Optus Stadium  W_Coast     Gold_Coast NA
```

Next - we edit the games data frame to add our tips. How you do this
will vary by how you actually store your tips - you might do a join with
your existing model output for example. I’ll leave that up to the user.
A simple example would be to provide a vector of margins.

Please note - these should always be the margin tip of the HOME TEAM.

``` r
games$Margin <- c(1, 6, 4, 4, 20, -1, -2, -12, -7)
games
#> # A tibble: 9 x 5
#>    Game Ground         Home        Away       Margin
#>   <int> <chr>          <chr>       <chr>       <dbl>
#> 1     1 MCG            Richmond    Carlton         1
#> 2     2 MCG            Collingwood W_Bulldogs      6
#> 3     3 MCG            Melbourne   Fremantle       4
#> 4     4 Adelaide Oval  Adelaide    Geelong         4
#> 5     5 Marvel Stadium Essendon    Hawthorn       20
#> 6     6 Gabba          Brisbane    Sydney         -1
#> 7     7 Marvel Stadium Kangaroos   P_Adelaide     -2
#> 8     8 GIANTS Stadium G_W_Sydney  St_Kilda      -12
#> 9     9 Optus Stadium  W_Coast     Gold_Coast     -7
```

Now we just pass this back with our original credentials and we are good
to go\!

``` r
submit_tips(games, user, pass, comp = comp)
#> Login succesfull!
#> Warning: `set_values()` was deprecated in rvest 1.0.0.
#> Please use `html_form_set()` instead.
#> Warning: `submit_form()` was deprecated in rvest 1.0.0.
#> Please use `session_submit()` instead.
#> # A tibble: 9 x 4
#>    Game Team        Margin Status  
#>   <int> <chr>        <int> <chr>   
#> 1     1 Richmond         1 Updated.
#> 2     2 Collingwood      6 Updated.
#> 3     3 Melbourne        4 Updated.
#> 4     4 Adelaide         4 Updated.
#> 5     5 Essendon        20 Updated.
#> 6     6 Sydney           1 Updated.
#> 7     7 P_Adelaide       2 Updated.
#> 8     8 St_Kilda        12 Updated.
#> 9     9 Gold_Coast       7 Updated.
```
