#' Title
#'
#' @param games_tbl 
#'
#' @return
#' @export
#'
#' @examples
extract_margin <- function(games_tbl){
  marg_exists <- any(names(games_tbl) %in% "Margin")
  
  if (!marg_exists) rlang::abort("Margin column does not exist in `games_tbl`")
  margin_names <- paste0("margingame", 1:nrow(games_tbl))
  setNames(as.list(games_tbl$Margin), margin_names)
}

#' Title
#'
#' @param games_tbl 
#'
#' @return
#' @export
#'
#' @examples
extract_std <- function(games_tbl){
  std_exists <- any(names(games_tbl) %in% "Std. Dev.")
  
  if (!std_exists) rlang::abort("Std Dev column does not exist in `games_tbl`")
  
  std_names <- paste0("stdgame", 1:nrow(games_tbl))
  setNames(as.list(games_tbl$`Std. Dev.`), std_names)
}

#' Title
#'
#' @param games_tbl 
#'
#' @return
#' @export
#'
#' @examples
extract_prob <- function(games_tbl){
  prob_exists <- any(names(games_tbl) %in% "Probability")
  
  if (!prob_exists) rlang::abort("Probability column does not exist in `games_tbl`")
  prob_game_names <- paste0("game", 1:nrow(games_tbl))
  setNames(as.list(games_tbl$Probability), prob_game_names)
}

#' Title
#'
#' @param games_tbl 
#'
#' @return
#' @export
#'
#' @examples
extract_which_game <- function(games_tbl){
  which_game_names <- paste0("whichgame", 1:nrow(games_tbl))
  games_tbl$game_result <- ifelse(games_tbl$Margin >= 0, "home", "away")
  setNames(as.list(games_tbl$game_result), which_game_names)
}

#' Title
#'
#' @param games_tbl 
#'
#' @return
#' @export
#'
#' @examples
extract_games <- function(games_tbl){
  game_names <- paste0("game", 1:nrow(games_tbl))
  games_tbl$game_result <- ifelse(games_tbl$Margin > 0, "home", "away")
  setNames(as.list(games_tbl$game_result), game_names)
}

#' Title
#'
#' @param form 
#'
#' @return
#' @export
#'
#' @examples
set_away_checkbox <- function(form) {
  names <- sapply(form$fields, function(x) '['(x, 'name')) %>% unlist() %>% unique()
  game_ids <- grepl("^game\\d$", names)
  for (field in names[game_ids]) {
    type <- form$fields[[field]]$type 
    value <- form$fields[[field]]$value 
    checked <- form$fields[[field]]$checked
    if (type == "radio" & value == "away" & is.null(checked)) {
      form$fields[[field]]$checked <- "checked"
    }
  }
  return(form)
}

#' Title
#'
#' @param games_tbl 
#' @param form 
#' @param comp 
#'
#' @return
#' @export
#'
#' @examples
convert_tips_to_form <- function(games_tbl, form, comp) {
  
  if (comp == "info") {
    prob_list <- extract_prob(games_tbl)
    params_list <- prob_list
    return(rlang::exec(rvest::set_values, form = form, !!!params_list))
  } else {
    margin_list <- extract_margin(games_tbl)
    games_tbl$Margin <- abs(games_tbl$Margin)
    margin_list <- extract_margin(games_tbl)
    
    if (comp == "normal") {
      game_list <- extract_games(games_tbl)
      params_list <- c(margin_list, game_list) 
    }
    
    if ( comp == "gauss") {
      std_list <- extract_std(games_tbl)
      game_list <- extract_which_game(games_tbl)
      params_list <- c(margin_list, game_list, std_list)
    }
    form_filled <- rlang::exec(rvest::set_values, form = form, !!!params_list)
    return(set_away_checkbox(form_filled))
  }

}
