#' @title create_stage
#' @description
#' creates new stage
#' @details
#' Creates a new stage in a given directory.
#'
#' @importFrom here here
#'
#' @param dir path to directory in which stage shall be created
#' @param name stage name: e.g. 01_preprocessing. Can't be empty
#' @param description short stage description. Can't be empty
#'
#' @keywords dso dvc yaml parameter
#'
#' @export
#'
#' @examples
#' \dontrun{
#' create_stage(name = "01_preprocessing", description = "Sequencing Preprocessing")
#' }
#'
create_stage <- function(dir = here::here(),
                         name = "",
                         description = "") {
  stage_path <- try(file.path(here::here(), name))
  if (name != "" & description != "" & !file.exists(stage_path)) {
    result <- system2(c(DSO_EXEC, "create", "stage", name, "--description", description))
    if (result != 0) {
      stop("Error: See Warning/Error Message!")
    } else {
      print(paste0("Success: ", name, " was created!"))
    }
  } else {
    stop("Stage already exists or name or description are not valid.")
  }
}
