user <- Sys.getenv("MONASH_USER")
pass <- Sys.getenv("MONASH_PASS")

skip_if_no_auth <- function() {
  if (identical(Sys.getenv("MONASH_USER"), "")) {
    skip("No authentication available")
  }
  if (identical(Sys.getenv("MONASH_PASS"), "")) {
    skip("No authentication available")
  }
}

test_that("Extract Normal Works", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  req_norm <- make_request(user, pass, comp = "normal")
  game_tbl_norm <- get_games_tbl(req_norm)
  form_norm <- get_form(req_norm)

  expect_type(extract_margin(game_tbl_norm), "list")
  expect_type(extract_games(game_tbl_norm), "list")

  expect_error(extract_std(game_tbl_norm))
  expect_error(extract_prob(game_tbl_norm))

  game_tbl_norm$Margin <- c(-1, 1, rep(0, times = nrow(game_tbl_norm) - 2))
  form_filled <- convert_tips_to_form(game_tbl_norm, 
                                      form = form_norm, 
                                      comp = "normal")
  expect_s3_class(form_filled, "rvest_form")
  expect_equal(form_filled$fields$game1$value, "away")
  expect_equal(form_filled$fields$game1$checked, "checked")
  expect_equal(form_filled$fields$game2$value, "home")
  #expect_equal(form_filled$fields$game2$checked, "checked")
})

test_that("Extract Gauss Works", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  req_gauss <- make_request(user, pass, comp = "gauss")
  game_tbl_gauss <- get_games_tbl(req_gauss)
  form_gauss <- get_form(req_gauss)

  expect_type(extract_margin(game_tbl_gauss), "list")
  expect_type(extract_std(game_tbl_gauss), "list")
  expect_type(extract_games(game_tbl_gauss), "list")
  expect_type(extract_which_game(game_tbl_gauss), "list")

  expect_error(extract_prob(game_tbl_gauss))

  game_tbl_gauss$Margin <- 0
  game_tbl_gauss$`Std. Dev.` <- 0
  expect_s3_class(convert_tips_to_form(game_tbl_gauss, 
                                       form = form_gauss, comp = "gauss"), 
                  "rvest_form")
})

test_that("Extract Info Works", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  req_info <- make_request(user, pass, comp = "info")
  game_tbl_info <- get_games_tbl(req_info)
  form_info <- get_form(req_info)

  expect_type(extract_prob(game_tbl_info), "list")

  expect_error(extract_margin(game_tbl_info))
  expect_error(extract_std(game_tbl_info))

  game_tbl_info$Probability <- 0.5
  expect_s3_class(convert_tips_to_form(game_tbl_info, 
                                       form = form_info, 
                                       comp = "info"), 
                  "rvest_form")
})
