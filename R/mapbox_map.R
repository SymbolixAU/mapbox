#' mapbox
#'
#' Plots a Mapbox GL JS map
#'
#' @import htmlwidgets
#'
#' @param token Mapbox Acess token.
#' @param data data to be used on the map. All coordinates are expected to be in
#' Web Mercator Projection
#' @param width the width of the map
#' @param height the height of the map
#' @param padding the padding of the map
#' @param style the style of the map. See \code{\link{mapbox_style}}
#' @param pitch the pitch angle of the map
#' @param zoom zoom level of the map
#' @param bearing bearing of the map between 0 and 360
#' @param location unnamed vector of lon and lat coordinates (in that order)
#' @param options list of options (See the example and \href{https://docs.mapbox.com/mapbox-gl-js/api/#map}{Mapbox Map API})
#' @param control list of optional controls. (See the example and \href{https://docs.mapbox.com/mapbox-gl-js/api/#user interface}{Mapbox User Interface API})
#'
#' @details
#' The \code{options} argument in the example contains 3 options, which are actually not options, but rather
#' plugins or additional layers, which can be included.
#'
#' \itemize{
#'   \item{buildings}
#'   \item{hillshade}
#'   \item{oceandepth}
#' }
#'
#' The option \code{gamelikecontrols} only works when \code{interactive} is set to FALSE.
#'
#' @examples \dontrun{
#' token <- "MAPBOX_TOKEN"
#'
#' mapbox(token = token, zoom = 10,
#'        location = c(-74.5447, 40.6892),
#'        style = mapbox_style(2),
#'        control = list(FullscreenControl = TRUE,
#'                       NavigationControl = TRUE,
#'                       Geocoder = TRUE,
#'                       GeolocateControl = TRUE,
#'                       Directions = TRUE,
#'                       ScaleControl = TRUE),
#'        options = list(buildings = TRUE,
#'                       hillshade = TRUE,
#'                       oceandepth = TRUE,
#'                       interactive = TRUE,
#'                       gamelikecontrols = FALSE,
#'                       attributionControl = TRUE,
#'                       customAttribution = "Hello There",
#'                       logoPosition = "top-left",
#'                       dragPan = TRUE,
#'                       scrollZoom = TRUE,
#'                       maxZoom = 10,
#'                       minZoom = 3,
#'                       maxBounds = list(-75.9876, 40.7661, -73.9397, 41.8002),
#'                       hash = TRUE))
#' }
#'
#' @export
mapbox <- function(
  data = NULL,
  token,
  width = NULL,
  height = NULL,
  padding = 0,
  style = mapbox_style(),
  pitch = 0,
  zoom = 0,
  bearing = 0,
  location = c( 0, 0 ),
  options = list(),
  control = NULL
) {

  # forward options using x
  x = list(
    access_token = force( token )
    , style = force( style )
    , pitch = force( pitch )
    , zoom = force( zoom )
    , location = force( as.numeric( location ) )
    , bearing = force( bearing )
    , options = force( options )
    , control = force( control )
  )


  # create widget
  mapboxmap <- htmlwidgets::createWidget(
    name = 'mapbox',
    x = structure(
      x,
      mapbox_data = data
    ),
    width = width,
    height = height,
    package = 'mapbox',
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = '100%',
      defaultHeight = 800,
      padding = padding,
      browser.fill = FALSE
    ),
    dependencies = mapboxDependency(control)
  )
  return(mapboxmap)
}

mapboxDependency <- function(control) {
  deps <- list()

  mapbox = createHtmlDependency(
    name = "mapboxgl",
    version = "0.52.0",
    src = system.file("htmlwidgets/lib", package = "mapbox"),
    script = c("mapbox-gl.js"),
    stylesheet = "mapbox-gl.css"
  )
  deps <- append(deps, list(mapbox))

  if (isTRUE(control[["Geocoder"]])) {
    geocoder = createHtmlDependency(
      name = "mapboxgeocoder",
      version = "4.4.1",
      src = system.file("htmlwidgets/lib", package = "mapbox"),
      script = c("mapbox_geocoder.js"),
      stylesheet = "mapbox_geocoder.css"
    )
    deps <- append(deps, list(geocoder))
  }
  if (isTRUE(control[["Directions"]])) {
    directions = createHtmlDependency(
      name = "mapboxdirections",
      version = "4.0.2",
      src = system.file("htmlwidgets/lib", package = "mapbox"),
      script = c("mapbox_directions.js"),
      stylesheet = "mapbox_directions.css"
    )
    deps <- append(deps, list(directions))
  }

  deps
}


#' Shiny bindings for mapbox
#'
#' Output and render functions for using mapbox within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a mapbox
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name mapbox-shiny
#'
#' @export
mapboxOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'mapbox', width, height, package = 'mapbox')
}

#' @rdname mapbox-shiny
#' @export
renderMapbox <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, mapboxOutput, env, quoted = TRUE)
}


#' mapbox update
#'
#' Update a mapbox map in a shiny app. Use this function whenever the map needs
#' to respond to reactive content.
#'
#' @param map_id string containing the output ID of the map in a shiny application.
#' @param session the Shiny session object to which the map belongs; usually the
#' default value will suffice.
#' @param data data to be used in the map. All coordinates are expected to be in
#' Web Mercator Projection
#' @param deferUntilFlush indicates whether actions performed against this
#' instance should be carried out right away, or whether they should be held until
#' after the next time all of the outputs are updated; defaults to TRUE.
#' @export
mapbox_update <- function(
  map_id,
  session = shiny::getDefaultReactiveDomain(),
  data = NULL,
  deferUntilFlush = TRUE
) {

  if (is.null(session)) {
    stop("mapbox_update must be called from the server function of a Shiny app")
  }

  structure(
    list(
      session = session,
      id = map_id,
      x = structure(
        list(),
        mapbox_data = data
      ),
      deferUntilFlush = deferUntilFlush,
      dependencies = NULL
    ),
    class = "mapbox_update"
  )
}
