test_that("dsoParams() creation of dsoParams objects", {
  x <- dsoParams()
  expect_s3_class(x, "dsoParams")
  expect_equal(length(x), 0)
  
  y <- list()
  y$a <- list()
  y$b <- "b"
  y$a$c <- "c"
  z <- dsoParams(y)
  
  expect_s3_class(z, "dsoParams")
  expect_s3_class(z$a, "dsoParams")
  
})


test_that("dsoParams() should fail when there is no input", {
  expect_error(dsoParams(NULL), "needs to be a list")
  expect_error(dsoParams(NA), "needs to be a list")
})

test_that("dsoParams() should retrieve value expected", {
  params <- list()
  params$a <- "bla"
  params$b <- list()
  params$b$c <- "blub"
  var_a <- "a"
  var_b <- "b"
  var_c <- "c"
  params <- dsoParams(params)
  
  expect_equal(params$a, "bla")
  expect_equal(params[[var_a]], "bla")
  expect_equal(params$b$c, "blub")
  expect_equal(params[["b"]]$c, "blub")
  expect_equal(params[['b']]$c, "blub")
  expect_equal(params[["b"]][['c']], "blub")
  expect_equal(params[['b']][["c"]], "blub")
  expect_equal(params[[var_b]][["c"]], "blub")
  expect_equal(params[["b"]][[var_c]], "blub")
  expect_equal(params[[var_b]][[var_c]], "blub")
})


test_that("access to dsoParams() with $ and [[", {
  params <- list()
  params$a <- "bla"
  params$b <- list()
  params$b$c <- "blub"
  var_a <- "a"
  var_b <- "b"
  var_c <- "c"
  var_z <- "z"
  params <- dsoParams(params)
  
  expect_error(params$z, "does not exist")
  expect_error(params[[var_z]], "does not exist")
  expect_error(params$z$c, "does not exist")
  expect_error(params[["z"]], "does not exist")
  expect_error(params[['z']], "does not exist")
  expect_error(params[["z"]]$c, "does not exist")
  expect_error(params[['z']]$c, "does not exist")
  expect_error(params[['b']]$z, "does not exist")
  expect_error(params[['z']]$c, "does not exist")
  expect_error(params[["b"]][['z']], "does not exist")
  expect_error(params[["z"]][['c']], "does not exist")
  expect_error(params[['b']][["z"]], "does not exist")
  expect_error(params[['z']][["c"]], "does not exist")
  expect_error(params[[var_b]][["z"]], "does not exist")
  expect_error(params[[var_z]][["c"]], "does not exist")
  expect_error(params[["z"]][[var_c]], "does not exist")
  expect_error(params[["b"]][[var_z]], "does not exist")
  expect_error(params[[var_b]][[var_z]], "does not exist")
  expect_error(params[[var_z]][[var_c]], "does not exist")
})

test_that("dsoParams: as.list() convertion", {
  y <- list()
  y$a <- list()
  y$b <- "b"
  y$a$c <- "c"
  y$a$d <- "d"
  y$a$e <- list()
  y$a$e$f <- "f"
  z <- dsoParams(y)
  
  l_z <- as.list(z)
  expect_type(l_z, "list")
  expect_equal(class(l_z), "list")
})

test_that("dsoParams: as.data.frame() convertion", {
  y <- list()
  y$a <- list()
  y$b <- "b"
  y$a$c <- "c"
  y$a$d <- "d"
  y$a$e <- list()
  y$a$e$f <- "f"
  z <- dsoParams(y)
  
  l_z <- as.data.frame(z)
  expect_s3_class(l_z, "data.frame")
})

