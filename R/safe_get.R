#' @title safe_get
#' @description
#' converts a nested list call to dollar format
#' @details
#' Converts a nested list call to dollar format while resolving variables
#' in the environment specified in `env` (by default the caller_env())
#' 
#' input_string <- 'CONFIG[[a]][[\"foo\"]]$bar[[\'no\']][[b]]$level'
#' a <- "test"
#' b <- "bla"
#' print(.convert_list_call_to_dollar_format('CONFIG[[a]][[\"foo\"]]$bar[["no"]][["further"]]$level')) 
#'   
#' @param input_string input string from deparsed function call
#' 
#' @param env environment which is used to resolve variables in the list call
#'
#' @importFrom stringr str_match_all
#' @importFrom stringr str_replace
#' @importFrom stringr coll
#' @importFrom rlang caller_env
#' @return converted nested list call in $ format
.convert_list_call_to_dollar_format <- function(input_string, env = caller_env()) {
  
  if(!is.null(input_string) && !is.na(input_string) && !is.character(input_string)) 
    stop("input_string is not a non-NULL non-NA character string")
  
  # Remove any whitespace
  x <- gsub("\\s", "", input_string)
  
  # Replace all $[[\"...\"]
  x <- gsub('\\[\\[\\"(.+?)\\"\\]\\]', "\\$\\1", x)
  
  # Replace all $[["..."]
  x <- gsub('\\[\\["(.+?)"\\]\\]', "\\$\\1", x)
  
  # Replace all $[[\'...\']
  x <- gsub("\\[\\[\\'(.+?)\\'\\]\\]", "\\$\\1", x)
  
  # Replace all $[['...']
  x <- gsub("\\[\\['(.+?)'\\]\\]", "\\$\\1", x)
  
  
  matches <- str_match_all(x, "\\[\\[(.*?)\\]\\]")
  
  # evaluates all variables in [[]] in environment specified
  # and returns function call as $ separated call
  if(!is.null(matches) && length(matches) > 0 && nrow(matches[[1]]) > 0 ) {
    for(i in 1:nrow(matches[[1]])) {
      tryCatch({
        .match = matches[[1]][i,1]
        .variable = matches[[1]][i,2]
        
        x <- str_replace(pattern     = coll(.match),
                         replacement = paste0("$", eval(parse(text = .variable),
                                                         envir = env)),
                         x)
      }, error = function(e) {
        stop(paste0("Error when trying to evaluate variable ", 
                    .variable," in '", x, "'.: ", e))
      })
    }
  }
  
  return(x)
}



#' @title safe_get
#' @description
#' safe checks a nested list call and returns requested value
#' @details
#' When accessing parameters stored in a list of list like `params$a$b$c`, 
#' R will return `NULL` if an empty slot is accessed intentionally or 
#' by accident: e.g. `params$a$d$c` (where `d` does not exist) will return
#' in `NULL`. This can lead to unwanted behavior. 
#' 
#' safe_get() will produce an error and point to the slot accessed incorrectly.
#' It can utilize other forms of access like params[["a"]]$b$c or 
#' var <- "a"; params[[a]]. Variables will be resolved from the caller_env()
#' by default, but can be changed passing through the `env` parameter.   
#'   
#' @param config_call nested list call
#' @param env environment which is used to resolve variables in the list call
#' @importFrom rlang caller_env
#' 
#' @export
#' @return content of nested variable call
safe_get <- function(config_call, env = caller_env()) {
  if (!is.environment(env)) {
    stop("env is not an environment or derived from an environment")
  }
  
  # input can be a mixture of $, [[ ]], variable, etc. This 
  # function converts everything into a uniform $ format while
  # evaluating the variables in the specified environment
  config_parts <- .convert_list_call_to_dollar_format(
      deparse(substitute(config_call)), env = env)
  
  # input checks
  error_prefix <- "config_call argument cannot be "
  error_postfix <- ". Input could be configuration stored in list of lists, e.g. params$test$a, params[['test']][['a']], params$test[['a']] or params[[ var]]$a." 
  if(config_parts == "NA") 
    stop(paste0(error_prefix, "NA", error_postfix))
  
  if(config_parts == "NULL")
    stop(paste0(error_prefix, "NULL", error_postfix))
  
  if(config_parts == "") 
    stop(paste0(error_prefix, "empty", error_postfix))
  
  # split the $ separated input string
  config_parts <- strsplit(config_parts, "\\$")[[1]] 
  
  # remove backticks `` to get the variable names
  config_parts <- gsub(pattern = "^`|`$", replacement = "", config_parts)
  
  # the first variable is the base variable
  current_list <- get(config_parts[1], envir = env, inherits = FALSE)
  
  if (is.null(current_list)) {
    stop(paste0(config_parts[0], " does not exist."))
  }
  
  # while iterating through the calls, check if the elements exist in the parent
  for (i in 2:length(config_parts)) {
    if (!exists(config_parts[[i]], envir = as.environment(current_list))) {
      stop(paste0("The element '", config_parts[[i]], "' does not exist in '", paste0(config_parts[1:(i-1)], collapse = "$"), "'."))
    }
    current_list <- current_list[[config_parts[[i]]]]
  }
  
  # return cannot be NULL
  if (is.null(current_list)) {
    stop(paste0("The call '", paste0(config_parts, collapse = "$"), "' is NULL."))
  }
  
  return(current_list)
}
