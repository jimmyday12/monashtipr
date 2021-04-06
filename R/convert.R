#' Extract margin
#'
#' Internal function to extract margin
#'
#'
#' @noRd
extract_margin <- function(games_tbl) {
  marg_exists <- any(names(games_tbl) %in% "Margin")

  if (!marg_exists) rlang::abort("Margin column does not exist in `games_tbl`")
  margin_names <- paste0("margingame", 1:nrow(games_tbl))
  stats::setNames(as.list(games_tbl$Margin), margin_names)
}

#' Extract which std
#'
#' Internal function to extract std
#'
#'
#' @noRd
extract_std <- function(games_tbl) {
  std_exists <- any(names(games_tbl) %in% "Std. Dev.")

  if (!std_exists) rlang::abort("Std Dev column does not exist in `games_tbl`")

  std_names <- paste0("stdgame", 1:nrow(games_tbl))
  stats::setNames(as.list(games_tbl$`Std. Dev.`), std_names)
}

#' Extract prob
#'
#' Internal function to extract prob
#'
#'
#' @noRd
extract_prob <- function(games_tbl) {
  prob_exists <- any(names(games_tbl) %in% "Probability")

  if (!prob_exists) rlang::abort("Probability column does not exist in `games_tbl`")
  prob_game_names <- paste0("game", 1:nrow(games_tbl))
  stats::setNames(as.list(games_tbl$Probability), prob_game_names)
}

#' Extract which game
#'
#' Internal function to extract games
#'
#'
#' @noRd
extract_which_game <- function(games_tbl) {
  which_game_names <- paste0("whichgame", 1:nrow(games_tbl))
  games_tbl$game_result <- ifelse(games_tbl$Margin >= 0, "home", "away")
  stats::setNames(as.list(games_tbl$game_result), which_game_names)
}

#' Extract game
#'
#' Internal function to extract games
#'
#'
#' @noRd
extract_games <- function(games_tbl) {
  game_names <- paste0("game", 1:nrow(games_tbl))
  games_tbl$game_result <- ifelse(games_tbl$Margin > 0, "home", "away")
  stats::setNames(as.list(games_tbl$game_result), game_names)
}

#' Set away checkbox
#'
#' Internal function to eset checkbox
#'
#'
#' @noRd
set_away_checkbox <- function(form) {
  names <- sapply(form$fields, function(x) "["(x, "name")) %>%
    unlist() %>%
    unique()
  game_ids <- grepl("^game\\d$", names)
  for (field in names[game_ids]) {
    type <- form$fields[[field]]$type
    value <- form$fields[[field]]$value
    checked <- form$fields[[field]]$checked
    if (type == "radio" & value == "away" & is.null(checked)) {
      form$fields[[field]]$checked <- "checked"
      
    }
    #print(paste(value, form$fields[[field]]$checked))
  }
  return(form)
}

#' Convert tips to form
#'
#' Internal function to convert tips to form
#'
#'
#' @noRd
convert_tips_to_form <- function(games_tbl, form, comp) {
  if (comp == "info") {
    prob_list <- extract_prob(games_tbl)
    params_list <- prob_list
    return(rlang::exec(rvest::html_form_set, form = form, !!!params_list))
  } else {
    margin_list <- extract_margin(games_tbl)
    
    if (comp == "normal") {
      game_list <- extract_games(games_tbl)
      params_list <- c(margin_list, game_list)
    }

    if (comp == "gauss") {
      game_list <- extract_which_game(games_tbl)
      std_list <- extract_std(games_tbl)
      params_list <- c(margin_list, game_list, std_list)
    }
    
    form_filled <- rlang::exec(rvest::html_form_set, 
                               form = form, 
                               !!!params_list)
    
    form_filled <- set_away_checkbox(form_filled)
    
    games_tbl$Margin <- abs(games_tbl$Margin)
    margin_list <- extract_margin(games_tbl)
    
    if (comp == "normal") {
      params_list <- c(margin_list, game_list)
    }
    
    if (comp == "gauss") {
      params_list <- c(margin_list, game_list, std_list)
    }
    
    form_filled <- rlang::exec(rvest::html_form_set, form = form_filled, !!!params_list)
    return(form_filled)
  }
}
