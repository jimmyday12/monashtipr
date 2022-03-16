

skip_if_no_auth <- function() {
  if (identical(Sys.getenv("MONASH_USER"), "")) {
    skip("No authentication available")
  }
  if (identical(Sys.getenv("MONASH_PASS"), "")) {
    skip("No authentication available")
  }
}

test_that("Get games works", {
  skip_if_offline()
  skip_on_cran()
  skip_if_no_auth()
  
  
  user <- Sys.getenv("MONASH_USER")
  pass <- Sys.getenv("MONASH_PASS")
  
  expect_s3_class(get_games(user, pass, comp = "normal"), "data.frame")
  expect_s3_class(get_games(user, pass, comp = "gauss"), "data.frame")
  expect_s3_class(get_games(user, pass, comp = "info"), "data.frame")
})
