user <- Sys.getenv("MONASH_USER")
pass <- Sys.getenv("MONASH_PASS")

test_that("make_request fails with bad arguments", {
  expect_error(make_request())
  expect_error(make_request("test", "test"))
  expect_error(make_request(user, pass, comp = "test"))
})

test_that("get_max_round works", {
  expect_error(get_max_round("1"))
  expect_type(get_max_round(), "double")
})


test_that("Request returns games", {
  req_norm <- make_request(user, pass, comp = "normal")
  req_gauss <- make_request(user, pass, comp = "gauss")
  req_info <- make_request(user, pass, comp = "info")
  
  expect_s3_class(req_norm, "response")
  expect_s3_class(req_gauss, "response")
  expect_s3_class(req_info, "response")
  
  
  expect_s3_class(get_games(req_norm), "data.frame")
  expect_s3_class(get_games(req_gauss), "data.frame")
  expect_s3_class(get_games(req_info), "data.frame")
  
  expect_error(get_games("1"))
})

test_that("Get games works", {
  expect_s3_class(get_current_games(user, pass, comp = "normal"), "data.frame")
  expect_s3_class(get_current_games(user, pass, comp = "gauss"), "data.frame")
  expect_s3_class(get_current_games(user, pass, comp = "info"), "data.frame")
})
