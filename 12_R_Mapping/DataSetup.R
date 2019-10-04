## load library ----------
library(dplyr)

## load data --------
rvdata <- read.csv(unz("data/RV2010_2018.zip", "RV2010_2018.csv"), stringsAsFactors = F)

#Filter the data for the standard RV survey stratified sets.
diversity <- rvdata%>%
  filter(XTYPE==1,grepl("NED",.$MISSION))%>%
  group_by(YEAR,MISSION,SETNO)%>%
  summarise(abundance = sum(TOTNO),
            div = n())%>% # n() is a handy dplyr function that returns the length of the data. Similar to nrow(data.frame) or length(vector)
  ungroup()%>% #ungroup because we want the proportion to be within YEAR and not set. 
  group_by(YEAR)%>% #regroup
  mutate(pdiv=div/max(div,na.rm=T))%>%
  ungroup()%>%
  right_join(.,rvdata%>%distinct(MISSION,SETNO,.keep_all=T)%>%
               select(ends_with("UDE"),MISSION,SETNO,YEAR),
             by=c("MISSION","SETNO","YEAR"))%>% #merge back in the coordinates so we can plot
  rename(long=LONGITUDE,lat=LATITUDE,year=YEAR)%>%
  filter(!is.na(div))%>%
  data.frame()

plotdata <- rvdata%>%
            filter(XTYPE==1,COMM %in% c("AMERICAN LOBSTER","COD(ATLANTIC)","CUSK"))%>%
            arrange(COMM)%>%
            select(COMM,MISSION,SETNO,YEAR,ends_with("UDE"),TOTWGT,TOTNO)%>%
            rename(species=COMM,long=LONGITUDE,lat=LATITUDE,wgt=TOTWGT,abund=TOTNO) # kind of clean up some of the names

#now plot it and use filter again if you want to subset out any specific species. 