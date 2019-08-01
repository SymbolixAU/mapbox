mapboxStyleDependency <- function() {
  list(
    createHtmlDependency(
      name = "style",
      version = "1.0.0",
      src = system.file("htmlwidgets/lib/style", package = "mapbox"),
      script = c("style.js"),
      all_files = FALSE
    )
  )
}


#' Add Style
#'
#' @export
add_style <- function( map, style ) {

  map <- mapbox:::addDependency(
    map, mapboxStyleDependency()
  )

  invoke_method(
    map, "mb_add_style", style
  )
}
