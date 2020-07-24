

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
get_round_games <- function(user, pass, round, comp) {
  
  # make request
  requ <- make_request(user, pass, round, comp)
  
  # get games
  get_games(requ)
  
}


#' Title
#'
#' @param games 
#' @param user 
#' @param pass 
#' @param round 
#' @param comp 
#'
#' @return
#' @export
#'
#' @examples
submit_tips <- function(games, user, pass, round, comp) {

  # make request
  sess <- create_session()
  requ <- make_request(user, pass, round, comp)
  form_unfilled <- get_form(requ)
  
  # add new fields
  form_filled <- convert_tips_to_form(games, form_unfilled, comp)
  
  # submit
  submit_form(sess, form_filled)
}
