#' Add source
#'
#' @details
#'
#' Mapbox sources supply data to be shown on the map. The type of source is specified
#' by the "type" property, ans must be one of
#' \itemize{
#'   \item{vector}
#'   \item{raster}
#'   \item{raster-dem}
#'   \item{geojson}
#'   \item{image}
#'   \item{video}
#' }
#'
#' See the Mapbox Sources definition at \url{https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources}
#'
#'
#' @examples
#' \donttest{
#'
#'
#'
#' }
#'
#'
#' @export
add_source <- function(map, id = NULL, js) {

  if( !inherits(map, "mapbox") ) {
    stop("expecting a mapbox map, perhaps you meant to use `mapbox()`?")
  }

  invoke_mapbox_method(
    map, "add_mapbox_source", id, js
  )
}

#' Add layer
#'
#' @examples
#' \donttest{
#' token <- "MAPBOX_TOKEN"
#'
#' ## Terrain in San Francisco, USA
#' js <- '{"id": "terrain-data",
#' 	"type": "line",
#' 	"source": {
#' 		"type": "vector",
#' 		"url": "mapbox://mapbox.mapbox-terrain-v2"
#' 	},
#' 	"source-layer": "contour",
#' 	"layout": {
#' 		"line-join": "round",
#' 		"line-cap": "round"
#' 	},
#' 	"paint": {
#' 		"line-color": "#ff69b4",
#' 		"line-width": 1
#' 	}}'
#'
#' mapbox(
#'   token = token
#'   , location = c(-122.44, 37.753)
#'   , zoom = 10
#' ) %>%
#'   add_mapbox_layer( js )
#'
#' ## 3-D buildings in New York, USA
#'
#' js <- '{"id": "3d-buildings",
#' "source": "composite",
#' "source-layer": "building",
#' "filter": ["==", "extrude", "true"],
#' "type": "fill-extrusion",
#' "minzoom": 15,
#' "paint": {
#' 	"fill-extrusion-color": "#aaa",
#' 	"fill-extrusion-height": [
#' 		"interpolate", ["linear"], ["zoom"],
#' 		15, 0,
#' 		15.05, ["get", "height"]
#' 		],
#' 	"fill-extrusion-base": [
#' 		"interpolate", ["linear"], ["zoom"],
#' 		15, 0,
#' 		15.05, ["get", "min_height"]
#' 		],
#' 	"fill-extrusion-opacity": 0.6
#' }}'
#'
#' mapbox(
#'   token = token
#'   , location = c(-74.0066, 40.7135)
#'   , zoom = 15
#'   , pitch = 45
#' ) %>%
#'   add_mapbox_layer( js )
#'
#' ## Terain in Cusco, Peru
#' source <- '{
#' 	"type": "vector",
#' 	"url": "mapbox://mapbox.mapbox-terrain-v2"
#' }'
#'
#' id <- 'contours'
#'
#' contours <- '{
#' 	"id": "contours",
#' 	"type": "line",
#' 	"source": "contours",
#' 	"source-layer": "contour",
#' 	"layout": {
#' 		"visibility": "visible",
#' 		"line-join": "round",
#' 		"line-cap": "round"
#' 	},
#' 	"paint": {
#' 		"line-color": "#877b59",
#' 		"line-width": 1
#' 	}
#' }'
#'
#' mapbox(
#'   token = token
#'   , location = c(-71.9675, -13.5320)
#'   , zoom = 10
#' ) %>%
#'   add_source(
#'     id = 'contours'
#'     , js = source
#'   ) %>%
#'   add_layer(
#'     js = contours
#'   )
#'
#' }
#'
#' @export
add_layer <- function(map, js) {

  if( !inherits(map, "mapbox") ) {
    stop("expecting a mapbox map, perhaps you meant to use `mapbox()`?")
  }

  invoke_mapbox_method(
    map, "add_mapbox_layer", js
  )
}


#' @export
clear_layer <- function(map, layer ) {
  invoke_mapbox_method(
    map, "clear_mabpox_layer", layer
  )
}
