test_that("safe_get() should fail when there is no input", {
  expect_error(safe_get(), "*empty*")
  expect_error(safe_get(NULL), "*NULL*")
  expect_error(safe_get(NA), "*NA*")
})

test_that("safe_get() should retrieve value expected", {
  params <- list()
  params$a <- "bla"
  params$b <- list()
  params$b$c <- "blub"
  var_a <- "a"
  var_b <- "b"
  var_c <- "c"

  expect_equal(safe_get(params$a), "bla")
  expect_equal(safe_get(params[[var_a]]), "bla")
  expect_equal(safe_get(params$b$c), "blub")
  expect_equal(safe_get(params[["b"]]$c), "blub")
  expect_equal(safe_get(params[["b"]]$c), "blub")
  expect_equal(safe_get(params[["b"]][["c"]]), "blub")
  expect_equal(safe_get(params[["b"]][["c"]]), "blub")
  expect_equal(safe_get(params[[var_b]][["c"]]), "blub")
  expect_equal(safe_get(params[["b"]][[var_c]]), "blub")
  expect_equal(safe_get(params[[var_b]][[var_c]]), "blub")
})


test_that("safe_get() should raise error when call does not exist", {
  params <- list()
  params$a <- "bla"
  params$b <- list()
  params$b$c <- "blub"
  var_a <- "a"
  var_b <- "b"
  var_c <- "c"
  var_z <- "z"

  expect_error(safe_get(params$z), "does not exist")
  expect_error(safe_get(params[[var_z]]), "does not exist")
  expect_error(safe_get(params$z$c), "does not exist")
  expect_error(safe_get(params[["z"]]), "does not exist")
  expect_error(safe_get(params[["z"]]), "does not exist")
  expect_error(safe_get(params[["z"]]$c), "does not exist")
  expect_error(safe_get(params[["z"]]$c), "does not exist")
  expect_error(safe_get(params[["b"]]$z), "does not exist")
  expect_error(safe_get(params[["z"]]$c), "does not exist")
  expect_error(safe_get(params[["b"]][["z"]]), "does not exist")
  expect_error(safe_get(params[["z"]][["c"]]), "does not exist")
  expect_error(safe_get(params[["b"]][["z"]]), "does not exist")
  expect_error(safe_get(params[["z"]][["c"]]), "does not exist")
  expect_error(safe_get(params[[var_b]][["z"]]), "does not exist")
  expect_error(safe_get(params[[var_z]][["c"]]), "does not exist")
  expect_error(safe_get(params[["z"]][[var_c]]), "does not exist")
  expect_error(safe_get(params[["b"]][[var_z]]), "does not exist")
  expect_error(safe_get(params[[var_b]][[var_z]]), "does not exist")
  expect_error(safe_get(params[[var_z]][[var_c]]), "does not exist")
})
