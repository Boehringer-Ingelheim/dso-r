#' A "dsoParams" and its constructor:
#'
#' @title dsoParams: list with safe access
#' @param x empty, or a recursive list of lists which is converted to dsoParams
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
  class(x) <- "dsoParams"
  return(x)
}


#' overriding the the $ operator to add secure list calling so that
#' it cannot return NULL when call does not exist
#' @param x dsoParams object
#' @param x name field name
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
