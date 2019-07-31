
<!-- README.md is generated from README.Rmd. Please edit that file -->

# So… what’s going on here?

Yeah, I know, [mapdeck](https://github.com/SymbolixAU/mapdeck) already
uses Mapbox\! But, it’s not straight forward controlling the underlying
map, like setting `maxBounds` (as requested in this
[issue](https://github.com/SymbolixAU/mapdeck/issues/41)), because the
map object isn’t a standard Mapbox `map` object.

For those of you interested, the map is defined in the `Deck`
constructor

``` js
const deckgl = new deck.DeckGL({
  mapboxApiAccessToken: x.access_token,
  container: el.id,
  mapStyle: x.style,
  layers: [],
});
```

Fortunately, Deck.gl also gives us a [Mapbox
Layer](https://github.com/uber/deck.gl/blob/master/docs/api-reference/mapbox/mapbox-layer.md),
which lets you use the Deck.gl layers on top of a standard Mapbox `map`
object.

For example

``` js
const map = new mapboxgl.Map({...});

const myScatterplotLayer = new MapboxLayer({
    id: 'my-scatterplot',
    type: ScatterplotLayer,
    data: [
        {position: [-74.5, 40], size: 100}
    ],
    getPosition: d => d.position,
    getRadius: d => d.size,
    getColor: [255, 0, 0]
});

// add to mapbox
map.addLayer(myScatterplotLayer);
```

So this package will give you the ‘standard’ Mapbox map, and I’m
updating [mapdeck](https://github.com/SymbolixAU/mapdeck) so it will
accept this Mapbox map object and add the layers accordingly.
