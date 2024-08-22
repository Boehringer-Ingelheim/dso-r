#' @title read_params
#' @description
#' Set stage dir and load parameters from params.yaml
#' @details
#' It is required to provide the path of the current stage relative to the project root to ensure that
#' the correct config is loaded, no matter of the current working directory (as long as the working directory
#' is any subdirectory of the project root). The function recompiles params.in.yaml to params.yaml on-the-fly
#' to ensure that up-to-date params are always loaded.
#'
#' @param stage_path relative path to stage directory from project root
#'
#' @importFrom yaml read_yaml
#' @export
read_params <- function(stage_path) {
  stage_path <- set_stage(stage_path)
  tmp_config_file <- tempfile()
  result <- system2(DSO_EXEC, c("get-config", shQuote(stage_path)), stdout = tmp_config_file)
  yaml <- read_yaml(tmp_config_file)
  unlink(tmp_config_file)
  yaml
}


#' @title set_stage
#' @description
#' Set stage dir
#' @details
#' It is required to provide the path of the current stage relative to the project root. The stage
#' dir is set, which allows the use of stage_here and the config_env variable stage_dir.
#' To get the path to the stage use stage_here(). stage_here() will return the absolute path to the
#' stage from the project root.
#'
#' @param stage_path relative path to stage directory from project root
#'
#' @importFrom here here
#' @importFrom here i_am
#' @importFrom glue glue
#'
#' @return absolute path to stage
#'
#' @export
set_stage <- function(stage_path) {
  # assuming there's a dvc.yaml in every stage
  # force the project dir to bet setup correctly.
  here::i_am(file.path(stage_path, "dvc.yaml"))
  stage_dir <- here::here(stage_path)
  message(glue::glue("stage_here() starts at {stage_dir}"))
  assign("stage_dir", stage_dir, envir = config_env)
  stage_dir
}

#' @title stage_here
#' @description
#' get absolute path to stage
#' @details
#' Get the absolute path to the current stage. The current stage can be set using set_stage()
#' by providing the relative path of the stage from the project root directory.
#' to the stage dir.
#' @export
#' @return absolute path to stage
stage_here <- function(...) {
  file.path(config_env$stage_dir, ...)
}
