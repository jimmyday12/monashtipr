

#' Get Games
#' 
#' get_current_games provides an API to return the current rounds matches in a data frame. 
#' 
#'
#' @param user monash username, in text
#' @param pass monash password, in text
#' @param comp comp type, should be one of "normal", "gauss" or "info"
#' @param round (optional),  round number to return. If not provided, will try find the current round.
#'
#' @return data.frame of the matches from the currently available tipping round
#' @export
#'
#' @examples
#' \dontrun{
#' get_games(user, pass, comp)
#' }
get_games <- function(user, pass, comp, round = NULL) {
  
  if (is.null(round)) get_current_round(user, pass)
  # make request
  requ <- make_request(user = user, pass = pass, comp = comp, round = round)
  # get games
  get_games_tbl(requ)
}


#' Submit Tips
#'
#' @param games a table of games, ideally returned from `get_games`
#' @param user monash username, in text
#' @param pass monash password, in text
#' @param comp comp type, should be one of "normal", "gauss" or "info"
#' @param round (optional),  round number to return. If not provided, will try find the current round.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' submit_tips(games, user, pass, comp)
#' }
submit_tips <- function(games, user, pass, comp, round = NULL) {

  if (is.null(round)) get_current_round(user, pass)
  
  # make request
  sess <- create_session()
  requ <- make_request(user, pass, comp, round = round)
  form_unfilled <- get_form(requ)
  
  # add new fields
  form_filled <- convert_tips_to_form(games, form_unfilled, comp)
  
  # submit
  result <- rvest::submit_form(sess, form_filled)
  result$response %>% 
    httr::content() %>% 
    rvest::html_node("h1+ table") %>% 
    rvest::html_table()
}
