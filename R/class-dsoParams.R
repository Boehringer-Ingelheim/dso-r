#' A "dsoParams" and its constructor:
#'
#' @title dsoParams: list with safe access
#' @param x empty, or a recursive list of lists which is converted to dsoParams
#'
#' @importFrom methods show
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

#' dsoParams class
#'
#' @slot params A list of lists containing parameters
#' @export
setClass("dsoParams",
         slots = list(
           params = "list"
         ))
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
#' @export
#' @param x dsoParams object
#' @param ... additional parameters are ignored
print.dsoParams <- function(x, ...) {
  cat(yaml::as.yaml(x))
}

#' Custom show method for dsoParams class
#' @param x dsoParams object
#' @export
setMethod(
  f = "show",
  signature = "dsoParams",
  definition = function(object) {
    cat(yaml::as.yaml(object))
  }
)

# Custom as.list method for dsoParams class
#' @export
setMethod(
  f = "as.list",
  signature = "dsoParams",
  definition = function(x) {
    lapply(x, function(y) {
      if ("dsoParams" %in% class(y)) {
        as.list(unclass(y))
      } else {
        x
      }
    })
  }
)
