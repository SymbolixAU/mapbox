
function mb_add_style( map_id, style ) {

  console.log("add_style");

  // TODO
  // need to wait until the map si loaded?

  var map = window[ map_id + 'map' ];
  map.setStyle(style);
}
