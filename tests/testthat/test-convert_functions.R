user <- Sys.getenv("MONASH_USER")
pass <- Sys.getenv("MONASH_PASS")

test_that("Extract Normal Works", {
  req_norm <- make_request(user, pass, comp = "normal")
  game_tbl_norm <- get_games_tbl(req_norm)
  form_norm <- get_form(req_norm)

  expect_type(extract_margin(game_tbl_norm), "list")
  expect_type(extract_games(game_tbl_norm), "list")

  expect_error(extract_std(game_tbl_norm))
  expect_error(extract_prob(game_tbl_norm))

  game_tbl_norm$Margin <- 0
  expect_s3_class(convert_tips_to_form(game_tbl_norm, form = form_norm, comp = "normal"), "form")
})

test_that("Extract Gauss Works", {
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
  expect_s3_class(convert_tips_to_form(game_tbl_gauss, form = form_gauss, comp = "gauss"), "form")
})

test_that("Extract Info Works", {
  req_info <- make_request(user, pass, comp = "info")
  game_tbl_info <- get_games_tbl(req_info)
  form_info <- get_form(req_info)

  expect_type(extract_prob(game_tbl_info), "list")

  expect_error(extract_margin(game_tbl_info))
  expect_error(extract_std(game_tbl_info))

  game_tbl_info$Probability <- 0.5
  expect_s3_class(convert_tips_to_form(game_tbl_info, form = form_info, comp = "info"), "form")
})
