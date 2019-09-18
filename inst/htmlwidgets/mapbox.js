 HTMLWidgets.widget({

  name: 'mapbox',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    return {

      renderValue: function(x) {

        var mapDiv = document.getElementById(el.id);
        mapDiv.className = 'mapboxmap';

        mapboxgl.accessToken = x.access_token;

        // Sets default or custom options
        if (x.options) {
          x.options.minZoom = set_option(x.options.minZoom, 0);
          x.options.maxZoom = set_option(x.options.maxZoom, 22);
          x.options.hash = set_option(x.options.maxZoom, false);
          x.options.interactive = set_option(x.options.interactive, true);
          x.options.bearingSnap = set_option(x.options.bearingSnap, 7);
          x.options.pitchWithRotate = set_option(x.options.pitchWithRotate, true);
          x.options.clickTolerance = set_option(x.options.clickTolerance, 3);
          x.options.attributionControl = set_option(x.options.attributionControl, true);
          x.options.customAttribution = set_option(x.options.customAttribution, "");
          x.options.logoPosition = set_option(x.options.logoPosition, "bottom-left");
          x.options.failIfMajorPerformanceCaveat = set_option(x.options.failIfMajorPerformanceCaveat, false);
          x.options.preserveDrawingBuffer = set_option(x.options.preserveDrawingBuffer, false);
          x.options.antialias = set_option(x.options.antialias, false);
          x.options.refreshExpiredTiles = set_option(x.options.refreshExpiredTiles, true);
          x.options.maxBounds = set_maxbound(x.options.maxBounds, null);
          x.options.scrollZoom = set_option(x.options.scrollZoom, true);
          x.options.boxZoom = set_option(x.options.boxZoom, true);
          x.options.dragRotate = set_option(x.options.dragRotate, true);
          x.options.dragPan = set_option(x.options.dragPan, true);
          x.options.keyboard = set_option(x.options.keyboard, true);
          x.options.doubleClickZoom = set_option(x.options.doubleClickZoom, true);
          x.options.touchZoomRotate = set_option(x.options.touchZoomRotate, true);
          x.options.trackResize = set_option(x.options.trackResize, true);
          x.options.renderWorldCopies = set_option(x.options.renderWorldCopies, true);
          x.options.maxTileCacheSize = set_option(x.options.maxTileCacheSize, null);
          x.options.localIdeographFontFamily = set_option(x.options.localIdeographFontFamily, "sans-serif");
          x.options.fadeDuration = set_option(x.options.fadeDuration, 300);
          x.options.crossSourceCollisions = set_option(x.options.crossSourceCollisions, true);
        }

        var map = new mapboxgl.Map({
        	container: el.id,
        	style: x.style,
        	zoom: x.zoom,
        	center: [x.location[0], x.location[1]],
        	pitch: x.pitch,
        	bearing: x.bearing,

        	minZoom: x.options.minZoom,
        	maxZoom: x.options.maxZoom,
        	hash: x.options.hash,
        	interactive: x.options.interactive,
        	bearingSnap: x.options.bearingSnap,
        	pitchWithRotate: x.options.pitchWithRotate,
        	clickTolerance: x.options.clickTolerance,
        	attributionControl: x.options.attributionControl,
        	customAttribution: x.options.customAttribution,
        	logoPosition: x.options.logoPosition,
        	failIfMajorPerformanceCaveat: x.options.failIfMajorPerformanceCaveat,
        	preserveDrawingBuffer: x.options.preserveDrawingBuffer,
        	antialias: x.options.antialias,
        	refreshExpiredTiles: x.options.refreshExpiredTiles,

        	maxBounds: x.options.maxBounds,
        	scrollZoom: x.options.scrollZoom,
        	boxZoom: x.options.boxZoom,
        	dragRotate: x.options.dragRotate,
        	dragPan: x.options.dragPan,
        	keyboard: x.options.keyboard,
        	doubleClickZoom: x.options.doubleClickZoom,
        	touchZoomRotate: x.options.touchZoomRotate,
        	trackResize: x.options.trackResize,
        	renderWorldCopies: x.options.renderWorldCopies,
        	maxTileCacheSize: x.options.maxTileCacheSize,
        	localIdeographFontFamily: x.options.localIdeographFontFamily,
        	fadeDuration: x.options.fadeDuration,
        	crossSourceCollisions: x.options.crossSourceCollisions,
        });

        // Add optional Control Widgets (https://docs.mapbox.com/mapbox-gl-js/api/#user%20interface)
        if (x.control) {
          // Add Geocoder (https://docs.mapbox.com/mapbox-gl-js/example/mapbox-gl-geocoder/)
          if (x.control.Geocoder) {
            map.addControl(new MapboxGeocoder({
              accessToken: mapboxgl.accessToken,
              mapboxgl: mapboxgl
            }));
          }
          // Add FullscreenControl (https://docs.mapbox.com/mapbox-gl-js/api/#fullscreencontrol)
          if (x.control.FullscreenControl) {
            map.addControl(new mapboxgl.FullscreenControl());
          }
          // Add NavigationControl (https://docs.mapbox.com/mapbox-gl-js/api/#navigationcontrol)
          if (x.control.NavigationControl) {
            map.addControl(new mapboxgl.NavigationControl());
          }
          // Add GeolocateControl (https://docs.mapbox.com/mapbox-gl-js/api/#geolocatecontrol)
          if (x.control.GeolocateControl) {
            map.addControl(new mapboxgl.GeolocateControl({
                positionOptions: {
                    enableHighAccuracy: true
                },
                trackUserLocation: true
            }));
          }
          // Add Directions (https://docs.mapbox.com/mapbox-gl-js/example/mapbox-gl-directions/)
          if (x.control.Directions) {
            map.addControl(new MapboxDirections({
              accessToken: mapboxgl.accessToken
            }), 'top-left');
          }
          // Add ScaleControl (https://docs.mapbox.com/mapbox-gl-js/api/#scalecontrol)
          if (x.control.ScaleControl) {
            var scale = new mapboxgl.ScaleControl({
                maxWidth: 100,
                unit: 'metric'
            });
            map.addControl(scale);
          }
        }


        window[el.id + 'map'] = map;

        //var checkExists = setInterval(function () {
        	map.on('load', function() {
        	  //console.log("map loaded");
        		//clearInterval(checkExists);

            // Define language of map
            //map.setLayoutProperty('country-label', 'text-field', ['get', 'name_de']);

            // Add 3D-Buildings (https://docs.mapbox.com/mapbox-gl-js/example/3d-buildings/)
            if (x.options.buildings) {
              // The 'building' layer in the mapbox-streets vector source contains building-height
              // data from OpenStreetMap.

              // Insert the layer beneath any symbol layer.
              var layers = map.getStyle().layers;
              var labelLayerId;
              for (var i = 0; i < layers.length; i++) {
                if (layers[i].type === 'symbol' && layers[i].layout['text-field']) {
                  labelLayerId = layers[i].id;
                  break;
                }
              }
              map.addLayer({
              'id': '3d-buildings',
              'source': 'composite',
              'source-layer': 'building',
              'filter': ['==', 'extrude', 'true'],
              'type': 'fill-extrusion',
              'minzoom': 15,
              'paint': {
                'fill-extrusion-color': '#aaa',

                // use an 'interpolate' expression to add a smooth transition effect to the
                // buildings as the user zooms in
                'fill-extrusion-height': [
                  "interpolate", ["linear"], ["zoom"],
                  15, 0,
                  15.05, ["get", "height"]
                ],
                'fill-extrusion-base': [
                  "interpolate", ["linear"], ["zoom"],
                  15, 0,
                  15.05, ["get", "min_height"]
                ],
                'fill-extrusion-opacity': 0.6
                }
              }, labelLayerId);
              }
            // Add Hillshade (https://docs.mapbox.com/mapbox-gl-js/example/hillshade/)
            if (x.options.hillshade) {
              map.addSource('dem', {
                "type": "raster-dem",
                "url": "mapbox://mapbox.terrain-rgb"
              });
              map.addLayer({
                "id": "hillshading",
                "source": "dem",
                "type": "hillshade"
                // insert below waterway-river-canal-shadow;
                // where hillshading sits in the Mapbox Outdoors style
              });
            }
            // Add Oceandepth (https://docs.mapbox.com/mapbox-gl-js/example/style-ocean-depth-data/)
            if (x.options.oceandepth) {
              map.addSource('10m-bathymetry-81bsvj', {
                type: 'vector',
                url: 'mapbox://mapbox.9tm8dx88'
              });
              map.addLayer({
                "id": "10m-bathymetry-81bsvj",
                "type": "fill",
                "source": "10m-bathymetry-81bsvj",
                "source-layer": "10m-bathymetry-81bsvj",
                "layout": {},
                "paint": {
                  "fill-outline-color": "hsla(337, 82%, 62%, 0)",
                  // cubic bezier is a four point curve for smooth and precise styling
                  // adjust the points to change the rate and intensity of interpolation
                  "fill-color":
                    [ "interpolate",
                      [ "cubic-bezier", 0, 0.5, 1, 0.5 ],
                      ["get", "DEPTH"],
                      200,  "#78bced",
                      9000, "#15659f"
                    ]
                }
                });
            }
            // Add Game-Like Controls (https://docs.mapbox.com/mapbox-gl-js/example/game-controls/)
            if (x.options.gamelikecontrols) {
              // pixels the map pans when the up or down arrow is clicked
              var deltaDistance = 100;

              // degrees the map rotates when the left or right arrow is clicked
              var deltaDegrees = 10;

              function easing(t) {
                return t * (2 - t);
              }

              map.getCanvas().focus();

              map.getCanvas().addEventListener('keydown', function(e) {
                e.preventDefault();
                if (e.which === 38) { // up
                  map.panBy([0, -deltaDistance], {
                    easing: easing
                  });
                } else if (e.which === 40) { // down
                  map.panBy([0, deltaDistance], {
                    easing: easing
                  });
                } else if (e.which === 37) { // left
                  map.easeTo({
                    bearing: map.getBearing() - deltaDegrees,
                    easing: easing
                  });
                } else if (e.which === 39) { // right
                  map.easeTo({
                    bearing: map.getBearing() + deltaDegrees,
                    easing: easing
                  });
                }
              }, true);
            }

        		mb_initialise_mapbox(el, x);
        	});
        //}, 100);

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
      }

    };
  }
});

function set_option(opt, def) {
  return typeof(opt) == "undefined" ? def : opt;
}
function set_maxbound(opt, def) {
  return typeof(opt) == "undefined" ? def : [[opt[0], opt[1]], [opt[2], opt[3]]];
}

function add_mapbox_layer( map_id, layer_json ) {
  var map = window[ map_id + 'map'];
  var js = JSON.parse( layer_json );
    map.addLayer( js );
}

function add_mapbox_source( map_id, id, source_json ) {
	var map = window[ map_id + 'map'];
  var js = JSON.parse( source_json );
	map.addSource( id,  js );
}

function clear_mapbox_layer( map_id, layer ) {
		var map = window[ map_id + 'map'];
		console.log( map );
		if (map.hasLayer( layer ) ) {
			map.removeLayer( layer );
		}
}

function clear_mapbox_source( map_id, source ) {
	var map = window[ map_id + 'map'];
		if (map.hasSource( source ) ) {
			map.removeSource( source );
		}
}

/*
function add_mapbox_layer( map_id, layer_json ) {
  var map = window[ map_id + 'map'];
  var js = JSON.parse( layer_json );
  map.on('styledata', function() {
    map.addLayer( js );
    console.log( map.getLayer( 'contours' ) );
  });
}
*/

if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler("mapboxmap-calls", function (data) {

    var id = data.id,   // the div id of the map
      el = document.getElementById(id),
      map = el,
      call = [],
      i = 0;

    if (!map) {
      //console.log("Couldn't find map with id " + id);
      return;
    }

    for (i = 0; i < data.calls.length; i++) {

      call = data.calls[i];

      //push the mapId into the call.args
      call.args.unshift(id);

      if (call.dependencies) {
        Shiny.renderDependencies(call.dependencies);
      }

      if (window[call.method]) {
        window[call.method].apply(window[id + 'map'], call.args);
      } else {
        //console.log("Unknown function " + call.method);
      }
    }
  });
}


function mb_initialise_mapbox(el, x) {

  //console.log("mb_initialise_map");

	// call initial layers
  if (x.calls !== undefined) {

    for (layerCalls = 0; layerCalls < x.calls.length; layerCalls++) {

      //push the map_id into the call.args
      x.calls[layerCalls].args.unshift(el.id);

      if (window[x.calls[layerCalls].functions]) {

        window[x.calls[layerCalls].functions].apply(window[el.id + 'map'], x.calls[layerCalls].args);

      } else {
        //console.log("Unknown function " + x.calls[layerCalls]);
      }
    }
  }
}
