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

test_that("make_request fails with bad arguments", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  expect_error(make_request())
  expect_error(make_request("test", "test"))
  expect_error(make_request(user, pass, comp = "test"))
})

test_that("finding rounds works", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  expect_error(get_rounds("1"))
  expect_type(get_rounds(), "double")
  expect_error(get_current_round())
  expect_type(get_current_round(user, pass), "double")
})


test_that("Request returns valid results", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  req_norm <- make_request(user, pass, comp = "normal")
  req_gauss <- make_request(user, pass, comp = "gauss")
  req_info <- make_request(user, pass, comp = "info")
  req_invalid_round <- make_request(user, pass, comp = "info", round = get_current_round(user, pass) - 1)

  expect_s3_class(req_norm, "response")
  expect_s3_class(req_gauss, "response")
  expect_s3_class(req_info, "response")

  expect_s3_class(get_games_tbl(req_norm), "data.frame")
  expect_s3_class(get_games_tbl(req_gauss), "data.frame")
  expect_s3_class(get_games_tbl(req_info), "data.frame")
  expect_s3_class(get_games_tbl(req_invalid_round), "data.frame")
  expect_error(get_games_tbl("1"))

  expect_s3_class(get_form(req_norm), "rvest_form")
  expect_s3_class(get_form(req_gauss), "rvest_form")
  expect_s3_class(get_form(req_info), "rvest_form")
  expect_error(get_form(req_invalid_round))
})

test_that("Checking session works", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  expect_s3_class(create_session(), "rvest_session")
  expect_error(create_session("1"))
})
