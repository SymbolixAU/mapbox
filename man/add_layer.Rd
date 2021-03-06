% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mapbox_layer.R
\name{add_layer}
\alias{add_layer}
\title{Add layer}
\usage{
add_layer(map, js)
}
\description{
Add layer
}
\examples{
\donttest{
token <- "MAPBOX_TOKEN"

## Terrain in San Francisco, USA
js <- '{"id": "terrain-data",
	"type": "line",
	"source": {
		"type": "vector",
		"url": "mapbox://mapbox.mapbox-terrain-v2"
	},
	"source-layer": "contour",
	"layout": {
		"line-join": "round",
		"line-cap": "round"
	},
	"paint": {
		"line-color": "#ff69b4",
		"line-width": 1
	}}'

mapbox(
  token = token
  , location = c(-122.44, 37.753)
  , zoom = 10
) \%>\%
  add_mapbox_layer( js )

## 3-D buildings in New York, USA

js <- '{"id": "3d-buildings",
"source": "composite",
"source-layer": "building",
"filter": ["==", "extrude", "true"],
"type": "fill-extrusion",
"minzoom": 15,
"paint": {
	"fill-extrusion-color": "#aaa",
	"fill-extrusion-height": [
		"interpolate", ["linear"], ["zoom"],
		15, 0,
		15.05, ["get", "height"]
		],
	"fill-extrusion-base": [
		"interpolate", ["linear"], ["zoom"],
		15, 0,
		15.05, ["get", "min_height"]
		],
	"fill-extrusion-opacity": 0.6
}}'

mapbox(
  token = token
  , location = c(-74.0066, 40.7135)
  , zoom = 15
  , pitch = 45
) \%>\%
  add_mapbox_layer( js )

## Terain in Cusco, Peru
source <- '{
	"type": "vector",
	"url": "mapbox://mapbox.mapbox-terrain-v2"
}'

id <- 'contours'

contours <- '{
	"id": "contours",
	"type": "line",
	"source": "contours",
	"source-layer": "contour",
	"layout": {
		"visibility": "visible",
		"line-join": "round",
		"line-cap": "round"
	},
	"paint": {
		"line-color": "#877b59",
		"line-width": 1
	}
}'

mapbox(
  token = token
  , location = c(-71.9675, -13.5320)
  , zoom = 10
) \%>\%
  add_source(
    id = 'contours'
    , js = source
  ) \%>\%
  add_layer(
    js = contours
  )

}

}
