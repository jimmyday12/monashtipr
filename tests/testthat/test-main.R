user <- Sys.getenv("MONASH_USER")
pass <- Sys.getenv("MONASH_PASS")

test_that("Get games works", {
  expect_s3_class(get_games(user, pass, comp = "normal"), "data.frame")
  expect_s3_class(get_games(user, pass, comp = "gauss"), "data.frame")
  expect_s3_class(get_games(user, pass, comp = "info"), "data.frame")
})
