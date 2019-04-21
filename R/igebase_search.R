#' Search information about data available through IGE API
#'
#' This funcion allows finds those tables that match the search term and
#' returns a data frame with results
#'
#' @param pattern Character string or regular expression to be matched.
#' @param fields Character vector of column name through which to search.
#' @param extra if \code{FALSE}, only the ID and label are returned,
#' if \code{TRUE}, all columns of the \code{cache} are returned.
#' @param exact Search for the exact pattern.
#' @param cache Data frame with metadata about API and IGE information.
#'
#' @return Data frame with metadata that match the search term.
#'
#' @export
#'
#' @examples
#' igebase_search("temperatura")
#' igebase_search("temperatura", extra = TRUE)
#'
#' # with regular expression operators
#' igebase_search(pattern = "temperatura|poboación")
#'
#' # with exact expression
#' igebase_search("Temperaturas e insolación", exact = TRUE)
#'
#'
igebase_search <- function(pattern, fields = "label", extra = FALSE, exact = FALSE, cache) {

  if(missing(cache)) cache <- igebaser::cache

  match_index <- sort(unique(unlist(sapply(fields, FUN = function(i)
    if(!exact) grep(pattern, cache[, i], ignore.case = TRUE)
    else grep(paste0("^",pattern,"$"), cache[, i], ignore.case = TRUE),
    USE.NAMES = FALSE)
  )))

  if (length(match_index) == 0) warning(paste0("No matches were found for the search term '", pattern,
                                               "'. Returning an empty data frame."))

  if (extra) {
    match_df <-  cache[match_index, ]
  } else {
    match_df <- cache[match_index, grep("label|ID",names(cache))]
  }

  match_df

}
