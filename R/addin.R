#' Execute dso repro and display the result
#' @export
dso_repro_addin <- function() {
  tryCatch({
    if (length(stage_here()) == 0) {
      stop("stage_here() is not defined. Please read in your config file using read_params().")
    } else {
      stage_path <- stage_here()
    }

    dvc_yaml_path <- file.path(stage_path, "dvc.yaml")

    tryCatch({
      message(glue::glue("Reproducing the current stage"))
      result <- system2(DSO_EXEC,
                        c("repro -s", shQuote(dvc_yaml_path)))
      if (result != 0) {
        stop("System command failed with status: {result}")
      }
      message("System command executed successfully")
    }, error = function(e) {
      glue::glue("An error occurred while executing dso repro")
    })

    report_files <- list.files(stage_here("report"), pattern = "\\.pdf$|\\.html$", full.names = TRUE)

    if (length(report_files) == 1) {
      report_file <- report_files[1]
      message(glue::glue("Report generated: {report_file}"))
      message(glue::glue("Displaying report file: {report_file}"))
      # Check the file extension and display in the viewer
          rstudioapi::viewer(report_file)
      } else {
      stop("No report file or multiple report files were identified. Please check the report directory.")
    }
  }, error = function(e) {
    message(glue::glue("An error occurred: {e$message}"))
  })
}
