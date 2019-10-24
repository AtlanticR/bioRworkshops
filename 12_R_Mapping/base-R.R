source('DataSetup.R')
d <- plotdata

plot(d$long, d$lat)

library(oce)
library(ocedata)

data("coastlineWorld")

plot(coastlineWorld)

plot(coastlineWorld, clatitude=44, clongitude=-62, span=2000)
points(d$long, d$lat)

data("coastlineWorldFine")

plot(coastlineWorldFine, clatitude=44, clongitude=-62, span=2000)
with(d[d$species == "AMERICAN LOBSTER",], points(long, lat, col='pink'))

points(d$long, d$lat, col=2)
points(d$long, d$lat, col=2)

mapPlot(coastlineWorld)
mapPoints(d$long, d$lat, col=2)
