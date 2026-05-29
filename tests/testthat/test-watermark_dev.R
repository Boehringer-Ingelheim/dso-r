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

test_that("config_env stores and clears dso config correctly", {
  # Verify storing dso config
  assign("dso", list(quarto = list(watermark = list(text = "TEST"))),
    envir = dso:::config_env
  )
  expect_equal(dso:::config_env$dso$quarto$watermark$text, "TEST")

  # Verify it can be removed (as read_params does when yaml$dso is NULL)
  rm("dso", envir = dso:::config_env)
  expect_null(dso:::config_env$dso)
})

test_that(".apply_watermark falls back to copy on failure", {
  # Create a temporary input file
  tmp_input <- tempfile(fileext = ".png")
  tmp_output <- tempfile(fileext = ".png")

  # Write some content to simulate an image
  writeBin(charToRaw("fake image content"), tmp_input)

  # Call .apply_watermark - dso is not installed, so it should fail and fall back
  expect_warning(
    dso:::.apply_watermark(tmp_input, tmp_output, list(text = "DRAFT")),
    "dso watermark failed"
  )

  # The fallback should copy the file
  expect_true(file.exists(tmp_output))
  expect_equal(readBin(tmp_input, "raw", 100), readBin(tmp_output, "raw", 100))

  # Clean up
  unlink(c(tmp_input, tmp_output))
})
