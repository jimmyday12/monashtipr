#' Get Rounds
#'
#' Internal function to finds all available rounds.
#'
#'
#' @noRd
get_rounds <- function() {
  url <- "http://probabilistic-footy.monash.edu/~footy/tips.shtml"
  round_text <- xml2::read_html(url) %>%
    rvest::html_nodes("tr:nth-child(4) select") %>%
    rvest::html_text()
  
  regmatches(round_text, gregexpr("[[:digit:]]+", round_text)) %>%
    unlist() %>%
    as.numeric()
}

#' Get Current Round
#'
#' Internal function to find the current round.
#'
#'
#' @noRd
get_current_round <- function(user, pass, rounds = get_rounds()) {
  valid_rounds <- rounds %>%
    purrr::map(~make_request(user, pass, comp = "normal", round = ., verbose = FALSE)) %>%
    purrr::map_lgl(purrr::pluck, "table_exists")
  
  if (sum(valid_rounds) == 0) return("")
  min(rounds[valid_rounds])
}

#' Make request
#'
#' FInternal function to make request
#'
#'
#' @noRd
make_request <- function(user, pass, comp, round = NULL, verbose = TRUE) {
  
  if( is.null(round)) round <- get_current_round(user, pass)
  url <- "http://probabilistic-footy.monash.edu/~footy/cgi-bin/presentTips.cgi.pl"
  params <- list(name = user, passwd = pass, round = round, comp = comp)

  if (!comp %in% c("info", "normal", "gauss")) {
    rlang::abort(glue::glue("`{comp}` is not a value for argument \"comp\".
    \"comp\" must be one of `info`, `normal` or `gauss`"))
  }

  req <- httr::POST(url, body = params, encode = "form")

  req <- check_request(req)
  
  if (verbose) rlang::inform(req$msg)
  return(req)
}

#' Check request
#'
#' Internal function to check the validity of a request object
#'
#'
#' @noRd
check_request <- function(req) {

  # check for table
  tables_count <- httr::content(req) %>% rvest::html_nodes("form table") %>% length()
  req$table_exists <- tables_count > 0
  if (req$table_exists) {
    req$msg <- "Login succesfull!" # Add tick
  } else {
    req$msg <- "Login failed - check username and password or that round is not in the past"
  }
  return(req)
  
}

#' Get Games Table
#'
#' Internal function to return a table
#'
#'
#' @noRd
get_games_tbl <- function(req) {
  if (req$table_exists) {
    rlang::inform("Returning current rounds games below...")
  games_tbl <- httr::content(req) %>%
    rvest::html_nodes("form table") %>%
    rvest::html_table() %>%
    .[[1]]
  } else {
    rlang::inform("Returning empty data frame")
    games_tbl <- data.frame()
  }
  return(games_tbl)
}

#' Get Form
#'
#' Internal function to return a form object
#'
#'
#' @noRd
get_form <- function(req) {
  if (req$table_exists) {
    
    httr::content(req) %>%
    rvest::html_node("form") %>%
    rvest::html_form()
  } else {
    rlang::abort("Invalid request made to `get_form`, most likely due to error in login credentials")
  }
}

#' Create session
#'
#' Internal function to create a session
#'
#'
#' @noRd
create_session <- function() {
  url <- "http://probabilistic-footy.monash.edu/~footy/cgi-bin/presentTips.cgi.pl"
  rvest::html_session(url)
}







