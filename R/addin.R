#' Execute dso repro and display the result
#'
#' This function reproduces the current stage without its dependencies
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
dso_repro_stage_addin <- function() {
  stage_path <- get_stage_path()
  dvc_yaml_path <- file.path(stage_path, "dvc.yaml")

  repro(dvc_yaml_path, single_stage = TRUE)

  check_report()
}

#' Execute dso repro with dependencies and display the result
#'
#' This function reproduces the current stage along its dependencies
#' and displays the resulting report in the RStudio Viewer pane.
#'
#' @return None
#' @export
#' @importFrom glue glue
#' @importFrom rstudioapi viewer
#' @examples
#' \dontrun{
#' dso_repro_stage_w_dependencies_addin()
#' }
dso_repro_stage_w_dependencies_addin <- function() {
  stage_path <- get_stage_path()
  dvc_yaml_path <- file.path(stage_path, "dvc.yaml")

  repro(dvc_yaml_path, single_stage = FALSE)

  check_report()
}

#' Get the current stage path
#'
#' This function retrieves the absolute path to the current stage.
#' If the stage is not defined, it stops with an error message.
#'
#' @return The absolute path to the current stage.
#' @noRd
get_stage_path <- function() {
  if (length(stage_here()) == 0) {
    stop(glue::glue("stage_here() is not defined. Please read in your config file using read_params()."))
  } else {
    return(stage_here())
  }
}

#' Check and display the report
#'
#' This function checks for the generated report files in the stage directory
#' and displays the report in the RStudio Viewer pane if a single report file is found.
#'
#' @return None
#' @noRd
#' @importFrom glue glue
#' @importFrom rstudioapi viewer
check_report <- function() {
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
}
