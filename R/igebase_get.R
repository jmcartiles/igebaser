#' Call the IGE API and return a formatted data frame
#'
#'
#' This function calls the IGE API, capture the data in CSV
#' format and it is formatted as data frame. To be used inside of \code{\link{igebase}}
#'
#' @param igebase_ID A character string. The \code{ID} code of the requested table.
#' @param show_metadata if \code{FALSE}, only get the data frame
#' if \code{TRUE}, show information of metadata.
#' Normally gived by the \code{\link{igebase_search}} function.
#' @param cache Data frame with tables from IGE API.
#'
#' @return A data frame.
#'
#' @examples
#' # Temperaturas e insolación.
#' df.temp <- igebase_get(520)
#' df.temp <- igebase_get(520, show_metadata = TRUE) # see information of metadata
#'
#'
igebase_get <- function(igebase_ID, show_metadata = FALSE, cache) {

  if(missing(cache)) cache <- igebaser::cache

  row.id <- grep(paste0("^", igebase_ID, "$"), cache$ID)
  if(length(row.id) == 0) {
    stop(
      paste0(
        "Please revise the parameter 'igebase_ID' choosen (",
        igebase_ID,
        "), it does not match with any 'indicador' in 'cache'.")
    )
  } else {
    type.cache <- cache[row.id,"tipo_cache"][[1]]
  }

  if(type.cache == "indicadores") url.base <- "http://www.ige.eu/igebdt/igeapi/csv/datosindi/"
  if(type.cache == "taboas") url.base <- "http://www.ige.eu/igebdt/igeapi/csv/datos/"
  if(type.cache == "series de coxuntura") url.base <- "http://www.ige.eu/igebdt/igeapi/csv/datosserc/"

  df <- utils::read.csv(paste0(url.base, igebase_ID))
  names(df) <- tolower(names(df))

  if(show_metadata == TRUE) {

    if(type.cache == "taboas") {
      raw.jsonstat <- readLines(paste0("http://www.ige.eu/igebdt/igeapi/jsonstat/datos/", igebase_ID),
                                warn = FALSE, encoding = "UTF-8")
      line.label <- min(grep("label", raw.jsonstat))
      line.updated <- min(grep("updated", raw.jsonstat))
      message(paste(raw.jsonstat[line.label:line.updated], collapse = "\n"))
    } else{
      warning("The parameter 'show_metadata' only has not values in this case.")
    }
  }

  if(nrow(df) == 0) stop(
    paste0(
      "There is not data available using (",
      igebase_ID,
      ").")
  )

  return(df)

}
