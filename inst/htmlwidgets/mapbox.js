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

        var map = new mapboxgl.Map({
        	container: el.id,
        	style: x.style,
        	zoom: x.zoom,
        	center: [x.location[0], x.location[1]],
        	pitch: x.pitch,
        	bearing: x.bearing
        });

        // TODO make this optional
        //map.addControl(new mapboxgl.NavigationControl());
        window[el.id + 'map'] = map;

        //var checkExists = setInterval(function () {
        	map.on('load', function() {
        	  console.log("map loaded");
        		//clearInterval(checkExists);
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

  console.log("mb_initialise_map");

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
