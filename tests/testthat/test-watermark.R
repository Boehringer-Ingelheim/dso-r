test_that("with_watermark calls fun with output_file when no config set", {
  if (exists("dso", envir = dso:::config_env)) {
    rm("dso", envir = dso:::config_env)
  }

  output_file <- tempfile(fileext = ".png")
  on.exit(unlink(output_file), add = TRUE)

  received <- NULL
  with_watermark(output_file, function(f) {
    received <<- f
    grDevices::png(filename = f)
    plot(1:5)
    grDevices::dev.off()
  })

  expect_identical(received, output_file)
  expect_true(file.exists(output_file))
})

test_that("with_watermark uses temp file when config is set", {
  assign("dso", list(quarto = list(watermark = list(text = "DRAFT"))),
    envir = dso:::config_env
  )
  on.exit(rm("dso", envir = dso:::config_env), add = TRUE)

  output_file <- tempfile(fileext = ".png")
  on.exit(unlink(output_file), add = TRUE)

  received <- NULL
  with_watermark(output_file, function(f) {
    received <<- f
    grDevices::png(filename = f)
    plot(1:5)
    grDevices::dev.off()
  })

  expect_false(identical(received, output_file))
  expect_match(received, "\\.png$")
  expect_true(file.exists(output_file))
  expect_gt(file.size(output_file), 0)
})

test_that("with_watermark works without config when overrides are passed", {
  skip_if_not(capabilities("cairo"), "SVG device requires Cairo support")

  if (exists("dso", envir = dso:::config_env)) {
    rm("dso", envir = dso:::config_env)
  }

  output_file <- tempfile(fileext = ".svg")
  on.exit(unlink(output_file), add = TRUE)

  with_watermark(output_file, function(f) {
    grDevices::svg(filename = f)
    plot(1:5)
    grDevices::dev.off()
  }, text = "FROM_OVERRIDE")

  svg_content <- paste(readLines(output_file, warn = FALSE), collapse = "\n")
  expect_match(svg_content, "FROM_OVERRIDE", fixed = TRUE)
})

test_that("with_watermark embeds watermark text in SVG output", {
  skip_if_not(capabilities("cairo"), "SVG device requires Cairo support")

  assign("dso",
    list(quarto = list(watermark = list(text = "TOPSECRET_MARKER"))),
    envir = dso:::config_env
  )
  on.exit(rm("dso", envir = dso:::config_env), add = TRUE)

  output_file <- tempfile(fileext = ".svg")
  on.exit(unlink(output_file), add = TRUE)

  with_watermark(output_file, function(f) {
    grDevices::svg(filename = f)
    plot(1:5)
    grDevices::dev.off()
  })

  svg_content <- paste(readLines(output_file, warn = FALSE), collapse = "\n")
  expect_match(svg_content, "TOPSECRET_MARKER", fixed = TRUE)
})

test_that("with_watermark accepts all watermark options including tile_size", {
  output_file <- tempfile(fileext = ".png")
  on.exit(unlink(output_file), add = TRUE)

  with_watermark(
    output_file,
    function(f) {
      grDevices::png(filename = f)
      plot(1:5)
      grDevices::dev.off()
    },
    text = "CONFIDENTIAL",
    tile_size = c(120L, 80L),
    font_size = 20L,
    font_outline = 2L,
    font_color = "#AAAAAA88",
    font_outline_color = "#000000FF"
  )

  expect_true(file.exists(output_file))
  expect_gt(file.size(output_file), 0)
})

test_that("with_watermark errors when callback does not produce file", {
  expect_error(
    with_watermark(
      tempfile(fileext = ".png"),
      function(f) invisible(NULL),
      text = "DRAFT"
    ),
    "did not produce"
  )
})

test_that("with_watermark propagates errors from callback", {
  output_file <- tempfile(fileext = ".png")
  expect_error(
    with_watermark(output_file, function(f) stop("boom"), text = "DRAFT"),
    "boom"
  )
  expect_false(file.exists(output_file))
})

test_that(".get_watermark_config returns NULL when no dso config", {
  if (exists("dso", envir = dso:::config_env)) {
    rm("dso", envir = dso:::config_env)
  }
  expect_null(dso:::.get_watermark_config())
})

test_that(".get_watermark_config returns watermark config when set", {
  assign("dso",
    list(quarto = list(watermark = list(text = "CONFIDENTIAL", opacity = 0.5))),
    envir = dso:::config_env
  )
  on.exit(rm("dso", envir = dso:::config_env), add = TRUE)

  expect_equal(
    dso:::.get_watermark_config(),
    list(text = "CONFIDENTIAL", opacity = 0.5)
  )
})

test_that(".get_watermark_config returns NULL when dso config has no watermark", {
  assign("dso", list(quarto = list(other = "value")),
    envir = dso:::config_env
  )
  on.exit(rm("dso", envir = dso:::config_env), add = TRUE)
  expect_null(dso:::.get_watermark_config())
})

test_that(".apply_watermark errors out on failure", {
  expect_error(
    dso:::.apply_watermark(
      tempfile(fileext = ".png"),
      tempfile(fileext = ".png"),
      list(text = "DRAFT")
    ),
    "dso watermark failed"
  )
})
