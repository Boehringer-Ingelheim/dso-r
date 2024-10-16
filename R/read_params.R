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
#' @param return_list returns a list if TRUE, by default it return `dsoParams` class which is a list with secure access 
#' @param quiet suppresses the warnings and errors of the `dso get-config` execution
#' 
#' @return parameters as list of list as `dsoParams` or conventional list when `return_list` is set.
#' @importFrom yaml read_yaml
#' @export
read_params <- function(stage_path, return_list = FALSE, quiet = FALSE) {
  if (!is.logical(quiet))
    stop("quiet argument must be either TRUE or FALSE.")
  
  if (!is.logical(return_list)) 
    stop("return_list argument must be either TRUE or FALSE.")
  
  arg_stderr = ""
  if (quiet) {
    arg_stderr = FALSE
  }
  
  # set the stage path
  stage_path <- set_stage(stage_path)
  
  # creating a temp file to store output of dso get-config
  tmp_config_file <- tempfile()
  
  # execute dso get-config and store ouput in temp file
  result <- system2(
                DSO_EXEC, 
                c("get-config", shQuote(stage_path)), 
                stdout = tmp_config_file,
                stderr = arg_stderr
            )
  
  # read the output of dso get-config as yaml
  yaml <- read_yaml(tmp_config_file)
  
  # remove the temp file
  unlink(tmp_config_file)
  
  # return as list or dsoParams object
  if(return_list) {
     yaml  
  } else {
     dsoParams(yaml)
  }
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
#' @param quiet surpresses messages if TRUE
#'
#' @importFrom here here
#' @importFrom here i_am
#' @importFrom glue glue
#'
#' @return absolute path to stage
#'
#' @export
set_stage <- function(stage_path, quiet = F) {
  # assuming there's a dvc.yaml in every stage
  # force the project dir to bet setup correctly.
  here::i_am(file.path(stage_path, "dvc.yaml"))
  
  # call here::here and surpresses messages if quiet is TRUE
  stage_dir <- withCallingHandlers(
    here::here(stage_path),
    message = function(e) if (quiet) invokeRestart("muffleMessage")
  )
  
  # report stage dir if quite is FALSE
  if(!quiet)
    message(glue::glue("stage_here() starts at {stage_dir}"))
  
  # sets the stage_dir variable
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
