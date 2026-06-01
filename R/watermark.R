#' @title with_watermark
#' @description
#' Run `fun(tmp_path)` and apply a watermark to the resulting file via the
#' `dso watermark` CLI.
#'
#' This mirrors the Python `dso.WatermarkedFile` context manager: `fun`
#' receives a path to write to, and once it returns, the file is watermarked
#' and moved to `output_file`. If no watermark configuration is available
#' (and no `...` overrides are given), `fun` is called with `output_file`
#' directly without any temp file or CLI invocation.
#'
#' Supports SVG, PDF and all pixel formats supported by `dso watermark`.
#'
#' @param output_file Path to the final (watermarked) image.
#' @param fun A function taking a single argument: the path to write the
#'   unwatermarked image to. The function's return value is discarded.
#' @param ... Watermark options overriding values from the global config
#'   (e.g. `text = "DRAFT"`, `tile_size = c(120L, 80L)`).
#'
#' @return `output_file`, invisibly.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Base graphics
#' with_watermark("myplot.png", function(f) {
#'   png(f)
#'   plot(1:10)
#'   dev.off()
#' })
#'
#' # ggplot2
#' p <- ggplot2::ggplot(data.frame(x = 1:10), ggplot2::aes(x, x)) +
#'   ggplot2::geom_point()
#' with_watermark("myplot.pdf", function(f) ggplot2::ggsave(f, p))
#'
#' # Override watermark text
#' with_watermark("myplot.svg", function(f) {
#'   svg(f)
#'   plot(1:10)
#'   dev.off()
#' }, text = "CONFIDENTIAL")
#' }
with_watermark <- function(output_file, fun, ...) {
  overrides <- list(...)
  existing <- .get_watermark_config()
  watermark_config <- utils::modifyList(
    if (is.null(existing)) list() else existing,
    overrides
  )

  # No watermark configured anywhere: just call fun with the real output path.
  if (length(watermark_config) == 0) {
    fun(output_file)
    return(invisible(output_file))
  }

  ext <- tools::file_ext(output_file)
  tmp_file <- tempfile(fileext = if (nzchar(ext)) paste0(".", ext) else "")
  on.exit(unlink(tmp_file), add = TRUE)

  fun(tmp_file)

  if (!file.exists(tmp_file)) {
    stop(
      "with_watermark: callback did not produce the expected file at ",
      tmp_file
    )
  }

  .apply_watermark(tmp_file, output_file, watermark_config)
  invisible(output_file)
}


#' Get watermark configuration from the global config environment
#' @return A list with watermark configuration or NULL
#' @keywords internal
.get_watermark_config <- function() {
  dso_config <- config_env$dso
  if (is.null(dso_config)) {
    return(NULL)
  }
  dso_config$quarto$watermark
}


#' Apply watermark to an image file using the dso CLI
#' @param input_file Path to the input image
#' @param output_file Path to the output (watermarked) image
#' @param watermark_config List with watermark configuration
#' @keywords internal
.apply_watermark <- function(input_file, output_file, watermark_config) {
  args <- c("watermark", shQuote(input_file), shQuote(output_file))

  for (key in names(watermark_config)) {
    value <- watermark_config[[key]]
    arg_name <- paste0("--", key)
    if (is.logical(value)) {
      if (isTRUE(value)) {
        args <- c(args, arg_name)
      }
    } else {
      args <- c(args, arg_name, shQuote(as.character(value)))
    }
  }

  result <- system2(DSO_EXEC, args, stdout = TRUE, stderr = TRUE)
  status <- attr(result, "status")

  if (!is.null(status) && status != 0) {
    stop(
      "dso watermark failed with status ", status, ".\n",
      "Output: ", paste(result, collapse = "\n")
    )
  }
}
