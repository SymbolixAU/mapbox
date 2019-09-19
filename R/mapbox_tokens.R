#' Mapbox_tokens
#'
#' Retrieves the mapbox token that has been set
#'
#' @export
mapbox_tokens <- function() {

  if(!is.na( getOption("mapbox")[["mapbox"]][["mapbox"]] ) ) {
    return( getOption("mapbox") )
  }

  if( !is.null( get_access_token() ) ){
    return( get_access_token() )
  }

  cat("no tokens found")
  return(invisible())

}

#' @export
print.mapbox_api <- function(x, ...) {

  for (i in 1:length(x)) {

    cat("Mapbox tokens\n")

    for (j in 1:length(x[[i]])){
      cat(" - ", names(x[[i]])[j], ": ")
      key <- x[[i]][[j]]
      cat(ifelse(is.na(key), "", key), "\n")
    }
  }
}

#' Set Token
#'
#' Sets an access token so it's available for all mapbox calls. See details
#'
#' @param token Mapbox access token
#'
#' @details
#' Use \code{set_token} to make access tokens available for all the \code{mapbox()}
#' calls in a session so you don't have to keep specifying the \code{token} argument
#' each time
#'
#' @export
set_token <- function(token) {

  options <- getOption("mapbox")
  api <- "mapbox" ## future-proofing for other api keys

  options[['mapbox']][[api]] <- token
  class(options) <- "mapbox_api"
  options(mapbox = options)
  invisible(NULL)
}


#' Clear tokens
#'
#' Clears the access tokens
#'
#' @export
clear_tokens <- function() {

  options <- list(
    mapbox = list(
      mapbox = NA_character_
    )
  )
  attr(options, "class") <- "mapbox_api"
  options(mapbox = options)

}

get_access_token <- function(api = "mapbox") {

  api <- getOption("mapbox")[['mapbox']][[api]]
  if( is.null( api ) || is.na( api ) ) {
    e <- Sys.getenv()
    e <- e[ grep( "mapbox", names( e ), ignore.case = TRUE ) ]

    api <- unique( as.character( e ) )
    if( length( api ) > 1 ) {
      warning("Multiple MAPBOX API tokens found in Sys.getenv(), using the first one")
    }
  }
  if(length(api) == 0) api <- NULL
  return(api[1L])
}

