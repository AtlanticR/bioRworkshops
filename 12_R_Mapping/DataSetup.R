## load library ----------
library(dplyr)
library(Mar.datawrangling)

## load data ----------
get_data('rv') #this will look in the data folder. THis assumes your root directory is the bioRworkshops repository
rvdata <- summarize_catches()

#Filter the data for the standard RV survey stratified sets.

rvdata <- filter(rvdata,XTYPE==1)

diversity <- rvdata%>%
  group_by(YEAR,MISSION,SETNO)%>%
  summarise(abundance = sum(TOTNO),
            div = n(), # n() is a handy dplyr function that returns the length of the data. Similar to nrow(data.frame) or length(vector)
            ldiversity = log10(div))%>%
  ungroup()%>% #ungroup because we want the proportion to be within YEAR and not set. 
  group_by(YEAR,MISSION)%>% #regroup
  mutate(pdiv=div/max(div,na.rm=T))%>%
  ungroup()%>%
  right_join(.,rvdata%>%select(ends_with("UDE"),MISSION,SETNO,YEAR),by=c("MISSION","SETNO","YEAR"))%>% #merge back in the coordinates so we can plot
  data.frame()

plotdata <- rvdata%>%
            filter(XTYPE==1,COMM %in% c("AMERICAN LOBSTER","COD(ATLANTIC)","CUSK"))%>%
            arrange(COMM)%>%
            select(COMM,MISSION,SETNO,YEAR,ends_with("UDE"),TOTWGT,TOTNO)%>%
            rename(species=COMM,long=ELONGITUDE,lat=ELATITUDE,wgt=TOTWGT,abund=TOTNO) # kind of clean up some of the names

#now plot it and use filter again if you want to subset out any specific species. 