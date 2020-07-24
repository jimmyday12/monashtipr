
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
make_request <- function(user = NULL,
                    pass = NULL,
                    round = NULL,
                    comp = NULL) {
  
  url <- "http://probabilistic-footy.monash.edu/~footy/cgi-bin/presentTips.cgi.pl"
  params <- list(
    name = user,
    passwd = pass,
    round = round,
    comp = comp)
  
  httr::POST(url, body = params, encode = "form") 

}

#' Title
#'
#' @param request 
#'
#' @return
#' @export
#'
#' @examples
get_games <- function(request) {
  httr::content(request) %>%
    rvest::html_nodes("form table") %>%
    rvest::html_table() %>%
    .[[1]]
}

#' Title
#'
#' @param request 
#'
#' @return
#' @export
#'
#' @examples
get_form <- function(request) {
    httr::content(request) %>%
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







