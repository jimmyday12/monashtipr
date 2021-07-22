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
    purrr::map(~make_request(user, pass,
                              comp = "normal", 
                              round = ., 
                              verbose = FALSE)) %>%
    purrr::map_lgl(purrr::pluck, "table_exists")

  if (sum(valid_rounds) == 0) {
    return("")
  }
  min(rounds[valid_rounds])
}

#' Make request
#'
#' FInternal function to make request
#'
#'
#' @noRd
make_request <- function(user, pass, comp, round = NULL, verbose = TRUE) {
  if (is.null(round)) round <- get_current_round(user, pass)

  if (!comp %in% c("info", "normal", "gauss")) {
    rlang::abort(glue::glue("`{comp}` is not a value for argument \"comp\".
    \"comp\" must be one of `info`, `normal` or `gauss`"))
  }

  url <-  rvest::read_html(
    "https://probabilistic-footy.monash.edu/~footy/tips.shtml"
  )
  
  login <- rvest::html_form(url)[[1]]
  
  params <- list(name = user, passwd = pass, round = round, comp = comp)
  
  login <- login %>% 
    rvest::html_form_set(!!!params)
  
  req <- rvest::html_form_submit(login)
  
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
  tables <- rvest::read_html(req) %>%
    rvest::html_table() 
  
  table_exists <- purrr::map(tables, names) %>%
    purrr::map_lgl(~"Game" %in% .) %>%
    any()
  
  req$table_exists <- table_exists
  
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
    
    tables <- rvest::read_html(req) %>%
      rvest::html_table() 
    
    # find table
    table_id <- purrr::map(tables, names) %>%
      purrr::map_lgl(~"Game" %in% .)
    
    games_tbl <- tables[[which(table_id)]]
    
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
      rvest::html_form(base_url = "https://probabilistic-footy.monash.edu/") %>%
      .[[1]]
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
  rvest::session(url)
}
