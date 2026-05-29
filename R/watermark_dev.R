#' @title watermark_dev
#' @description
#' Create a graphics device that applies watermarking via `dso watermark`.
#' @details
#' Wraps an existing graphics device function (e.g., `png`, `pdf`) so that
#' the resulting image is piped through `dso watermark` before being saved
#' to the final location. The watermark configuration is read from the global
#' config environment (set by `read_params`).
#'
#' If no watermark configuration is available, the original device is returned
#' unmodified.
#'
#' When used with `ggsave()`, watermarking is applied automatically after the
#' device is closed. When used with base graphics, call `dev.off()` as normal -
#' the watermark will be applied automatically.
#'
#' @param dev A graphics device function (e.g., `grDevices::png`, `grDevices::pdf`, `grDevices::svg`)
#'
#' @return A graphics device function that applies watermarking
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Usage with base graphics
#' watermark_dev(png)(filename = "myplot.png")
#' plot(1:10)
#' dev.off()
#'
#' # Usage with ggplot2
#' p <- ggplot2::ggplot(data.frame(x = 1:10), ggplot2::aes(x)) +
#'   ggplot2::geom_point(ggplot2::aes(y = x))
#' ggplot2::ggsave("myplot.png", p, device = watermark_dev(png))
#' }
watermark_dev <- function(dev) {
  # Get watermark config from the global config environment
  watermark_config <- .get_watermark_config()

  # If no watermark config is available, return the original device
  if (is.null(watermark_config) || length(watermark_config) == 0) {
    return(dev)
  }

  # Return a new device function that wraps the original
  function(filename, ...) {
    # Create a temporary file with the same extension as the target
    ext <- paste0(".", tools::file_ext(filename))
    tmp_file <- tempfile(fileext = ext)
    final_file <- filename

    # Open the original device writing to the temporary file
    dev(filename = tmp_file, ...)

    # Get the device number of the just-opened device
    dev_num <- grDevices::dev.cur()

    # Add a task callback that checks if the device has been closed
    # and applies the watermark when it is
    addTaskCallback(function(...) {
      # Check if the device is still open
      if (!(dev_num %in% grDevices::dev.list())) {
        # Device has been closed, apply watermark
        .apply_watermark(tmp_file, final_file, watermark_config)
        unlink(tmp_file)
        # Return FALSE to remove the callback
        return(FALSE)
      }
      # Return TRUE to keep the callback active
      return(TRUE)
    }, name = paste0("dso_watermark_", dev_num))

    invisible(NULL)
  }
}


#' Get watermark configuration from the global config environment
#' @return A list with watermark configuration or NULL
#' @keywords internal
.get_watermark_config <- function() {
  dso_config <- config_env$dso
  if (is.null(dso_config)) {
    return(NULL)
  }
  watermark_config <- dso_config$quarto$watermark
  watermark_config
}

#' Apply watermark to an image file using the dso CLI
#' @param input_file Path to the input image
#' @param output_file Path to the output (watermarked) image
#' @param watermark_config List with watermark configuration
#' @keywords internal
.apply_watermark <- function(input_file, output_file, watermark_config) {
  # Build the dso watermark command arguments
  args <- c("watermark", shQuote(input_file), shQuote(output_file))

  # Add watermark configuration as CLI arguments
  for (key in names(watermark_config)) {
    value <- watermark_config[[key]]
    arg_name <- paste0("--", gsub("_", "-", key))
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
    warning(
      "dso watermark failed with status ", status, ".\n",
      "Output: ", paste(result, collapse = "\n"), "\n",
      "The unwatermarked image will be used instead."
    )
    # Fall back to copying the unwatermarked file
    file.copy(input_file, output_file, overwrite = TRUE)
  }
}
