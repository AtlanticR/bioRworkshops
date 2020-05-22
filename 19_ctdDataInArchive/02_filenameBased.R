rm(list=ls())
library(oce)
library(ocedata)
data('coastlineWorldFine')
load('data.rda')

filenames <- unlist(lapply(d, function(k) tail(strsplit(k[['filename']], '\\\\')[[1]],1)))

# we know that Prince 5 always has the same cruise name
#    so let's find it based on the filename
princeok <- grepl(pattern = '^CTD_BCD\\w+669_\\w+_\\w+_DN\\.ODF$',
                  x = filenames)
pd <- d[princeok]
plon <- unlist(lapply(pd, function(k) k[['longitude']]))
plat <- unlist(lapply(pd, function(k) k[['latitude']]))

proj <- '+proj=merc'
fillcol <- 'lightgray'
lonlim <- range(plon) + c(-0.3, 0.3)
latlim <- range(plat) + c(-0.3, 0.3)

par(mar = c(2.5, 2.5 , 1.5, 1))
mapPlot(coastlineWorldFine, 
        longitudelim = lonlim,
        latitudelim = latlim,
        col = fillcol, 
        proj = proj,
        grid = c(0.5, 0.5))
mapPoints(plon, plat)

Tlim <- range(unlist(lapply(pd, function(k) k[['temperature']])))
plotProfile(pd[[1]], xtype = 'temperature', col = 'white', Tlim = Tlim)
lapply(pd, function(k) lines(k[['temperature']], k[['pressure']]))
