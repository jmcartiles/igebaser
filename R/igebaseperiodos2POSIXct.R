#' Add a POSIXct dates to a IGE base API return
#'
#' Add a POSIXct date column as well as a column with the
#' appropiate granularity to a IGE base API return
#'
#' @param df data frame returned from API call
#'
#' @return The original data frame with two new columns, \code{periodo} and \code{periodicidade} is returned.
#'
#'
igebasecodtempo2POSIXct <- function(df) {

  df <- transform(df, periodo = as.POSIXct(NA),
                  periodicidade = NA)

  df.codtempo <- df[,"codtempo"]


  annual.index <- which(nchar(as.character(df.codtempo)) == 4)
  if (length(annual.index) > 0) {

    df$periodo[annual.index] <- as.POSIXct(paste0(df.codtempo[annual.index], "-01-01"))
    df$periodicidade[annual.index] <- "anual"

  }

  trimestral.index <- which(nchar(as.character(df.codtempo)) > 4 & substr(as.character(df.codtempo), 5,6) > 12)
  if (length(trimestral.index) > 0) {

    trimestre <- as.numeric(substr(df.codtempo[trimestral.index], 5,6))
    trimestre.cache <- lapply(c(13,14,15,16), function(x) grep(x, trimestre))

    for (i in 1:4) trimestre[trimestre.cache[[i]]] <- c("-01","-04","-07","-10")[i]

    df$periodo[trimestral.index] <- as.POSIXct(paste0(substr(df.codtempo[trimestral.index],1,4),trimestre,"-01"))
    df$periodicidade[trimestral.index] <- "trimestral"

  }

  mensual.index <- which(nchar(as.character(df.codtempo)) > 4 & substr(as.character(df.codtempo), 5,6) <= 12)
  if (length(mensual.index) > 0) {

    df$periodo[mensual.index] <- as.POSIXct(paste0(substr(df.codtempo[mensual.index],1,4),
                                                   "-",
                                                   substr(df.codtempo[mensual.index], 5,6),
                                                   "-01"))
    df$periodicidade[mensual.index] <- "mensual"

  }

  return(df)

}
