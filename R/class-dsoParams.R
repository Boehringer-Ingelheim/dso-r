#' dsoParams class
#'
#' @slot params A list of lists containing parameters
#' @export
setClass("dsoParams",
  slots = list(
    params = "list"
  )
)

#' A "dsoParams" and its constructor:
#'
#' @title dsoParams: list with safe access
#' @param x empty, or a recursive list of lists which is converted to dsoParams
#'
#' @examples
#' # initiating empty
#' params <- dsoParams()
#'
#' # converting a list of list
#'
#' params <- list()
#' params$a <- "bla"
#' params$b <- list()
#' params$b$c <- "blub"
#' params <- dsoParams(params)
#'
#' @export
dsoParams <- function(x = list()) {
  if (!is.list(x)) {
    stop("x needs to be a list or a list of lists.")
  }
  # recursively
  x <- lapply(x, function(y) {
    if (is.list(y)) {
      dsoParams(y)
    } else {
      y
    }
  })
  class(x) <- c("dsoParams", "list")
  return(x)
}

#' overriding the the $ operator to add secure list calling so that
#' it cannot return NULL when call does not exist
#' @param x dsoParams object
#' @param name field name
#' @export
`$.dsoParams` <- function(x, name) {
  if (!name %in% names(x)) {
    stop(paste("Element '", name, "' does not exist in dsoParams", sep = ""))
  }

  NextMethod()
}

#' And the [[ operator:  to add secure list calling so that
#' it cannot return NULL when call does not exist
#' @param x dsoParams object
#' @param i index for `[[` operator
#' @param ... additional arguments passed to the `[[` operator
#' @export
`[[.dsoParams` <- function(x, i, ...) {
  if (is.character(i) && !i %in% names(x)) {
    stop(paste("Element '", i, "' does not exist in dsoParams", sep = ""))
  } else if (is.numeric(i) && (i < 1 || i > length(x))) {
    stop(paste("Index '", i, "' is out of bounds in dsoParams", sep = ""))
  }


  NextMethod()
}

#' Custom print method for dsoParams class
#' @param x dsoParams object
#' @param ... additional parameters are ignored
#' @export
print.dsoParams <- function(x, ...) {
  cat(yaml::as.yaml(x))
}

#' Custom show method for dsoParams class
#' @importFrom methods show
#' @param object dsoParams object
#' @export
setMethod(
  f = "show",
  signature = "dsoParams",
  definition = function(object) {
    cat(yaml::as.yaml(object))
  }
)

#' Custom as.list method for dsoParams class
#' @param x dsoParams object
#' @return A list
#' @export
setMethod(
  f = "as.list",
  signature = "dsoParams",
  definition = function(x) {
    lapply(x, function(y) {
      if ("dsoParams" %in% class(y)) {
        as.list(unclass(y))
      } else {
        y
      }
    })
  }
)


#' @title reload function
#' @description
#'
#' Generic for function reload
#'
#' @param object dsoParams config object
#' @export
setGeneric("reload", function(object, ...) standardGeneric("reload"))


#' @title reload dso params
#' @description
#' reloads the current dsoParams config into object
#'
#' @param object dsoParams object
#' @param env environment in which object is located, caller_env() by default
#' @export
setMethod("reload", "dsoParams", function(object, env = caller_env()) {
  if (!inherits(object, "dsoParams")) {
    stop("The object is not of class 'dsoParams'")
  }

  var_name <- deparse(substitute(object))
  assign(var_name, value = read_params(), envir = env)

  invisible(get(var_name, envir = env))
})
