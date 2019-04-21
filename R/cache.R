#' Cached information from the IGE API
#'
#' This data is a cached result of the accesibles tables and indicators using the IGE API.
#' By default functions \code{\link{igebase}} and \code{\link{igebase_search}} use this
#' data for the \code{cache} parameter.
#'
#' This data was updated on April 2019.
#'
#' @format A data frame with 7101 observations and 5 variables:
#'
#' \describe{
#'     \item{tema}{Main topic}
#'     \item{label}{It is the name of the table or indicator}
#'     \item{source}{It indicates the source of data}
#'     \item{tipo_cache}{It indicates the type of data}
#'     \item{ID}{Identificator}
#' }
#'
#'
"cache"
