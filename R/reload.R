#' @title Reload dsoParams
#' @description
#' Reloads the current dsoParams configuration into the object.
#'
#' @param params dsoParams object
#' @param env environment in which object is located, caller_env() by default
#' @return The updated dsoParams object.
#' @export
reload <- function(params, env = caller_env()) {
  if (!inherits(params, "dsoParams")) {
    stop("The object is not of class 'dsoParams'")
  }
  var_name <- deparse(substitute(params))
  assign(var_name, value = read_params(), envir = env)

  invisible(get(var_name, envir = env))
}
