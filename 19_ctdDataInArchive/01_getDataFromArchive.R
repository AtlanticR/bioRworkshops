rm(list=ls())
library(oce)

path <- 'R:/Science/BIODataSvc/ARC/Archive/ctd/2017'
files <- list.files(path = path,
                    pattern = '^.*DN\\.ODF$',
                    full.names = TRUE)
d <- lapply(files, read.ctd.odf)
save(d, file = 'data.rda')