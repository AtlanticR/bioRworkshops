## load library ----------
library(dplyr)

## load data --------
rvdata <- read.csv(unz("../data/RV2010_2018.zip", "RV2010_2018.csv"), stringsAsFactors = F)

plotdata <- rvdata %>%
            filter(XTYPE==1,COMM %in% c("AMERICAN LOBSTER","COD(ATLANTIC)","CUSK")) %>%
            arrange(COMM) %>%
            select(COMM,MISSION,SETNO,YEAR,ends_with("UDE"),TOTWGT,TOTNO) %>%
            rename(species=COMM,long=LONGITUDE,lat=LATITUDE,wgt=TOTWGT,abund=TOTNO) # kind of clean up some of the names

