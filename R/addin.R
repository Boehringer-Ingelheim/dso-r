#' Execute dso repro and display the result
#'
#' This function runs the `dso repro` command on the specified `dvc.yaml` file
#' and displays the resulting report in the RStudio Viewer pane.
#'
#' @return None
#' @export
#' @importFrom glue glue
#' @importFrom rstudioapi viewer
#' @examples
#' \dontrun{
#' dso_repro_stage_addin()
#' }
#' @export
dso_repro_stage_addin <- function() {
  tryCatch(
    {
      if (length(stage_here()) == 0) {
        stop(glue::glue("stage_here() is not defined. Please read in your config file using read_params()."))
      } else {
        stage_path <- stage_here()
      }

      dvc_yaml_path <- file.path(stage_path, "dvc.yaml")

      message(glue::glue("Reproducing the current stage"))
      result <- system2(
        DSO_EXEC,
        c("repro -s", shQuote(dvc_yaml_path))
      )
      if (result != 0) {
        stop(glue::glue("DSO repro -s failed with status: {result}"))
      } else {
          message("System command executed successfully")
      }

      report_files <- list.files(stage_here("report"), pattern = "\\.pdf$|\\.html$", full.names = TRUE)

      if (length(report_files) == 1) {
        report_file <- report_files[1]
        message(glue::glue("Report generated: {report_file}"))
        message(glue::glue("Displaying report file: {report_file}"))
        # Check the file extension and display in the viewer
        rstudioapi::viewer(report_file)
      } else {
        stop(glue::glue("No report file or multiple report files were identified. Please check the report directory."))
      }
    },
    error = function(e) {
      message(glue::glue("An error occurred: {e$message}"))
    }
  )
}

dso_repro_stage_w_dependencies_addin <- function() {
  tryCatch(
    {
      if (length(stage_here()) == 0) {
        stop(glue::glue("stage_here() is not defined. Please read in your config file using read_params()."))
      } else {
        stage_path <- stage_here()
      }

      dvc_yaml_path <- file.path(stage_path, "dvc.yaml")

      message(glue::glue("Reproducing the current stage with all its dependency stages."))
      
      result <- system2(
        DSO_EXEC,
        c("repro", shQuote(dvc_yaml_path))
      )
      
      if (result != 0) {
        stop(glue::glue("DSO repro -s failed with status: {result}"))
      } else {
          message("System command executed successfully")
      }

      report_files <- list.files(stage_here("report"), pattern = "\\.pdf$|\\.html$", full.names = TRUE)

      if (length(report_files) == 1) {
        report_file <- report_files[1]
        message(glue::glue("Report generated: {report_file}"))
        message(glue::glue("Displaying report file: {report_file}"))
        # Check the file extension and display in the viewer
        rstudioapi::viewer(report_file)
      } else {
        stop(glue::glue("No report file or multiple report files were identified. Please check the report directory."))
      }
    },
    error = function(e) {
      message(glue::glue("An error occurred: {e$message}"))
    }
  )
}
