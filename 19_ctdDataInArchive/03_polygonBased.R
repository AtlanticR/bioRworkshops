rm(list=ls())
library(oce)
library(ocedata)
data('coastlineWorldFine')
library(sp)
load('data.rda')

# ranges to find station data
# stn 2 : -63.3175, 44.2675
polylat <- c(44.17, 44.17, 44.37, 44.37)
polylon <- c(-63.42, -63.22, -63.22, -63.42)

lon <- unlist(lapply(d, function(k) k[['longitude']]))
lat <- unlist(lapply(d, function(k) k[['latitude']]))

pip <- point.in.polygon(lat, lon,
                        polylat, polylon)
hd <- d[pip != 0]

hlon <- unlist(lapply(hd, function(k) k[['longitude']]))
hlat <- unlist(lapply(hd, function(k) k[['latitude']]))

proj <- '+proj=merc'
fillcol <- 'lightgray'
lonlim <- range(hlon) + c(-0.3, 0.3)
latlim <- range(hlat) + c(-0.1, 0.5)

par(mar = c(2.5, 2.5 , 1.5, 1))
mapPlot(coastlineWorldFine, 
        longitudelim = lonlim,
        latitudelim = latlim,
        col = fillcol, 
        proj = proj,
        grid = c(0.5, 0.5))
mapPolygon(polylon, polylat)
mapPoints(hlon, hlat)

Tlim <- range(unlist(lapply(hd, function(k) k[['temperature']])))
plotProfile(hd[[1]], xtype = 'temperature', col = 'white', Tlim = Tlim)
lapply(hd, function(k) lines(k[['temperature']], k[['pressure']]))
