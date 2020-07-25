#' Get Round
#'
#' Finds the current round.
#'
#'
#' @noRd
get_max_round <- function() {
  url <- "http://probabilistic-footy.monash.edu/~footy/tips.shtml"
  round_text <- xml2::read_html(url) %>%
    rvest::html_nodes("tr:nth-child(4) select") %>%
    rvest::html_text()
  matches <- regmatches(round_text, gregexpr("[[:digit:]]+", round_text)) %>%
    unlist() %>%
    as.numeric()
  
  max(matches)
  
}

#' Title
#'
#' @param user
#' @param pass
#' @param round
#' @param comp
#'
#' @return
#' @export
#'
#' @examples
make_request <- function(user, pass, comp, round = NULL) {

  if( is.null(round)) round <- get_max_round()
  url <- "http://probabilistic-footy.monash.edu/~footy/cgi-bin/presentTips.cgi.pl"
  params <- list(name = user, passwd = pass, round = round, comp = comp)

  if (!comp %in% c("info", "normal", "gauss")) {
    rlang::abort(glue::glue("`{comp}` is not a value for argument \"comp\".
    \"comp\" must be one of `info`, `normal` or `gauss`"))
  }

  req <- httr::POST(url, body = params, encode = "form")

  req <- check_request(req)
  
  rlang::inform(req$msg)
  return(req)
}

#' Title
#'
#' @param req 
#'
#' @return
#' @export
#'
#' @examples
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

#' Title
#'
#' @param request
#'
#' @return
#' @export
#'
#' @examples
get_games <- function(req) {
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

#' Title
#'
#' @param request
#'
#' @return
#' @export
#'
#' @examples
get_form <- function(req) {
    httr::content(req) %>%
    rvest::html_node("form") %>%
    rvest::html_form()
}

#' Title
#'
#' @return
#' @export
#'
#' @examples
create_session <- function() {
  url <- "http://probabilistic-footy.monash.edu/~footy/cgi-bin/presentTips.cgi.pl"
  rvest::html_session(url)
}







