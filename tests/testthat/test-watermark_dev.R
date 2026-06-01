test_that("watermark_dev returns original device when no config is set", {
  # Ensure no dso config is set
  if (exists("dso", envir = dso:::config_env)) {
    rm("dso", envir = dso:::config_env)
  }

  result <- watermark_dev(png)
  expect_identical(result, png)
})

test_that("watermark_dev returns a wrapper function when config is set", {
  # Set up watermark config
  assign("dso", list(quarto = list(watermark = list(text = "DRAFT"))),
    envir = dso:::config_env
  )

  result <- watermark_dev(png)
  expect_true(is.function(result))
  expect_false(identical(result, png))

  # Clean up
  rm("dso", envir = dso:::config_env)
})

test_that(".get_watermark_config returns NULL when no dso config", {
  if (exists("dso", envir = dso:::config_env)) {
    rm("dso", envir = dso:::config_env)
  }

  result <- dso:::.get_watermark_config()
  expect_null(result)
})

test_that(".get_watermark_config returns watermark config when set", {
  assign("dso", list(quarto = list(watermark = list(text = "CONFIDENTIAL", opacity = 0.5))),
    envir = dso:::config_env
  )

  result <- dso:::.get_watermark_config()
  expect_equal(result, list(text = "CONFIDENTIAL", opacity = 0.5))

  # Clean up
  rm("dso", envir = dso:::config_env)
})

test_that(".get_watermark_config returns NULL when dso config has no watermark", {
  assign("dso", list(quarto = list(other = "value")),
    envir = dso:::config_env
  )

  result <- dso:::.get_watermark_config()
  expect_null(result)

  # Clean up
  rm("dso", envir = dso:::config_env)
})
