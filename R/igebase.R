#' Download data from the IGE API
#'
#' This function downloads the requested information using the IGE API.
#'
#' @param igebase_ID A character string or numeric value. The \code{ID} code of the requested table.
#' This \code{ID} corresponds to the \code{ID} column from \code{\link{cache}}.
#' @param code_region Character string or regular expression to be matched. It is used to find a region using
#' the province or municipality code is provided by INE. This parameter can not be use with \code{region}.
#' @param region Character string or regular expression to be matched. It is used to find a region by its name.
#' This parameter can not be used with \code{code_region}.
#' @param POSIXct if \code{TRUE}, two new columns, \code{periodo} and \code{periodicidade} are added.
#' Useful for \code{freq} filter, if \code{FALSE}, these fields are not added.
#' @param label if \code{TRUE}, the label of te requested dataframe is returned, if \code{FALSE} it is not returned.
#' @param startdate Character string. Must be in "yyyy-mm-dd" form.
#' @param enddate Character string. Must be in "yyyy-mm-dd" form.
#' @param freq Character string. For fetching yearly ("anual"), quaterly ("trimestral"), monthly ("mensual") values.
#' @param show_metadata if \code{FALSE}, only get the data frame
#' if \code{TRUE}, show information of metadata, used in \code{\link{igebase_get}}.
#' @param cache Data frame with tables from IGE API.
#'
#' @return Data frame with all available requested data.
#'
#' @export
#'
#' @examples
#'# Información climatolóxica por meses e estacións meteorolóxicas.
#' df <- igebase(1651, POSIXct = TRUE, label = TRUE, freq = "anual", show_metadata = TRUE)
#'
#'# Autosuficiencia en emprego using 'code_region'.
#' df <- igebase(7405, code_region ="15|12", label = TRUE)
#'
#'# Autosuficiencia en emprego using 'region'.
#' df <- igebase(7405, region ="Galicia|Vigo")
#'
igebase <- function(igebase_ID,
                     code_region = NA, region = NA,
                     POSIXct = FALSE,
                     label = FALSE,
                     startdate, enddate,
                     freq,
                     show_metadata = FALSE,
                     cache) {

  if(missing(cache)) cache <- igebaser::cache

  df <- igebase_get(igebase_ID, show_metadata = show_metadata)

  # only use 1 region/code_region parameter
  if(!is.na(code_region)+!is.na(region) > 1) stop("Parameter 'code_region' and 'region' can not be used together.")

  # code_region
  if(!is.na(code_region)) {
    if(!any(grepl(code_region, df$codespazo))) stop("Please revise 'code_region', it does not match a valid value.")
    else {
      df <- df[grep(code_region, df$codespazo),]
    }
  }

  # region
  if(!is.na(region)) {
    if(!any(grepl(region, df$espazo))) stop("Please revise 'region', it does not match a valid value.")
    else{
      df <- df[grep(region, df$espazo),]
    }
  }

  # label
  if(label) {
    label.indicator <- as.character(
      cache[cache$ID == igebase_ID, "label"]
    )
    df <- transform(df, label = label.indicator)
  }

  # POSIXct
  if(POSIXct) {

    if("codtempo" %in% names(df)) {

      df <- igebasecodtempo2POSIXct(df)

      if(!missing(startdate)) df <- df[df$periodo >= as.POSIXct(startdate),]
      if(!missing(enddate)) df <- df[df$periodo <= as.POSIXct(enddate),]

      if(!missing(freq)) {
        df <- df[df$periodicidade == freq,]
        if(nrow(df) == 0) warning("The selected 'freq' is not correct.")
      }

    } else {

      warning("The data is not time dependent.")

    }

  } else {
    if(!missing(startdate) | !missing(enddate) | !missing(freq))
      warning("The parameters startdate, enddate, freq are ignored when POSCIXct is set to FALSE.")
  }

  return(df)

}
