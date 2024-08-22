#' @title compile_config
#' @description
#' Run dso compile-config
#' @details
#' This function runs the dso compile-config command and updates the params.yaml with info from other params.in.yaml and params.yaml.
#'
#' @keywords dso dvc yaml compile config
#'
#' @export
#'
#' @examples
#' \dontrun{
#' compile_config()
#' }
#'
compile_config <- function(dir = getwd()) {
  result <- system2(DSO_EXEC, c("compile-config", shQuote(dir)))
  if (result != 0) {
    stop("Error: See Warning/Error Message!")
  }
}
