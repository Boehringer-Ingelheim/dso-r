#' @title Reproduce a dso stage
#' @description
#' Reproduce a dso stage with or without its dependencies.
#' @details
#' This function reproduces a stage specified by `stage_path`. If `single_stage` is set to `TRUE`,
#' it reproduces the stage without its dependencies. Otherwise, it reproduces the current stage along with all its dependency stages.
#' By default, the current stage will be reproduced.
#' @param stage_path The path to a stage. Defaults to the current stage by using `stage_here()`.
#' @param single_stage Logical flag indicating whether to reproduce only the current stage (`TRUE`) or the current stage with all dependencies (`FALSE`). Defaults to `FALSE`.
#' @export
repro <- function(stage_path = stage_here(), single_stage = F) {
  if (single_stage) {
    message(glue::glue("Reproducing the current stage with all its dependency stages."))
    repro_cmd <- "repro"
  } else {
    message(glue::glue("Reproducing the current stage without dependencies."))
    repro_cmd <- "repro -s"
  }
      result <- system2(
        DSO_EXEC,
        c(repro_cmd, shQuote(file.path(stage_path, "dvc.yaml")))
      )

      if (result != 0) {
        stop(glue::glue("DSO {repro_cmd} failed with status: {result}"))
      } else {
          message("dso repro was executed successfully")
      }
}

