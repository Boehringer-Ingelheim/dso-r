#' @title init
#' @description
#' initialise new project
#' @details
#' Initialises a new project in a given directory.
#'
#' @importFrom here here
#'
#' @param dir path to directory in which project shall be initialised
#' @param name project name: e.g. BI_907828_1403_MDM2. Can't be empty
#' @param description short project description. Can't be empty
#'
#' @keywords dso dvc yaml parameter project
#'
#' @export
#'
#' @examples
#' \dontrun{
#' init(name = "BI_907828_1403_MDM2", description = "MDM2 Project")
#' }
#'
init <- function(dir = here::here(),
                 name = "",
                 description = "") {
  stage_path <- try(file.path(here::here(), name))
  if (name != "" & description != "" & !file.exists(stage_path)) {
    result <- system2(c(DSO_EXEC, "init", name, "--description", description))
    if (result != 0) {
      stop("Error: See Warning/Error Message!")
    } else {
      print(paste0("Success: The project ", name, " was created!"))
    }
  } else {
    stop("Project already exists or name or description are not valid.")
  }
}
