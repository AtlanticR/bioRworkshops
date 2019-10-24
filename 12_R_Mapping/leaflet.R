require(leaflet)

leaflet(plotdata) %>%
    addTiles() %>%
    addMarkers(~long,~lat)