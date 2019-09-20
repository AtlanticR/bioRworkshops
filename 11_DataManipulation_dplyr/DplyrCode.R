## Introduction to data manipulation using dplyr

#Dplyr grammar (verbs) of data manipulation

    #glimpse()
    #select() - ends_with(), contains(), starts_with()
    #arrange()
    #filter() - between()
    #mutate()
    #group_by()
    #summarise()

## load library ----------
library(dplyr)
library(Mar.datawrangling)

## load map function ----------
source("11_DataManipulation_dplyr/makemap.R")

## load data ----------
get_data('rv') #this will look in the data folder
rvdata <- summarize_catches()
#rvdata <- read.csv("RV2010_2018.csv",stringsAsFactors = F)

## load mapping function ----
source("makemap.R")

## glimpse ---------- inspect data
glimpse(rvdata) #similar to str(rvdata)

 
## select ------------ select specific columns

head(select(rvdata,SETNO,YEAR,LATITUDE,LONGITUDE,TOTWGT,COMM)) #notice how the data is moved through this with pipes pathway

#use sub-order functions to quickly extract names quickly
head(select(rvdata,starts_with("XT")))
head(select(rvdata,ends_with("UDE")))
head(select(rvdata,contains("TEMP")))
#bring this together
head(select(rvdata,starts_with("XT"),ends_with("UDE"),contains("TEMP"),YEAR))

## arrange ------------- arrange rows

head(arrange(rvdata,-TOTWGT))
head(arrange(rvdata,YEAR))
head(arrange(rvdata,YEAR,COMM,-TOTWGT),25) # you can quickly stack the arrange

## rename --------- rename columns

head(rvdata%>%rename(species=COMM))

## piping ------------- splice verbs together

# the pipe operator: %>% is imported from another package (magrittr).
# This operator allows you to pipe the output from one function to the input of another function. 
# Instead of nesting functions (reading from the inside to the outside), 
# the idea of of piping is to read the functions from left to right.

head(arrange(rvdata,YEAR,COMM,-TOTWGT)) #nested can get messy

rvdata%>%arrange(YEAR,COMM,-TOTWGT)%>%head

rvdata%>%
  select(ends_with("UDE"),contains("TEMP"),YEAR,COMM,TOTWGT)%>%
  arrange(YEAR,COMM,-TOTWGT)%>%
  head

rvdata%>%
  select(ends_with("UDE"),contains("TEMP"),YEAR,COMM,TOTWGT)%>%
  arrange(-DMIN)%>%
  head ## ORDER MATTERS
  
rvdata%>%
  arrange(-DMIN)%>%
  select(ends_with("UDE"),contains("TEMP"),YEAR,COMM,TOTWGT)%>%
  rename(species=COMM)%>%
  head ## ORDER MATTERS

## filter -------- select specific rows

filter(rvdata,YEAR==2010)%>%head

filter(rvdata,YEAR==2010)%>%
  arrange(COMM,-TOTWGT)%>%
  glimpse

filter(rvdata,YEAR==2010,XTYPE==1,COMM %in% c("COD(ATLANTIC)","AMERICAN LOBSTER"))%>%
  arrange(COMM,-TOTWGT)%>%
  glimpse

filter(rvdata,YEAR==2010,XTYPE==1,COMM %in% c("COD(ATLANTIC)","AMERICAN LOBSTER"))%>%
  arrange(COMM,-TOTWGT)%>%
  select(COMM,YEAR)%>%
  glimpse

filter(rvdata,between(YEAR,2010,2012),between(TOTWGT,10,14),COMM=="AMERICAN LOBSTER")

### sampling ------------ select random rows

rvdata%>%sample_n(5)
rvdata%>%sample_frac(0.02)%>%head

### mutate ------------- create a new column with the same dimensions as you started

rvdata%>%mutate(dAVE = (DMIN+DMAX)/2)%>%head

rvdata%>%mutate(dAVE = mean(c(DMIN,DMAX)))%>%head #NA because mean doesn't know what to do

rvdata%>%mutate(dAVE = rowMeans(select(.,starts_with("DM"))))%>%head

rvdata%>%mutate(dAVE = (DMIN+DMAX)/2,
                wAVE = TOTWGT/TOTNO)%>%head

## group_by ------------ apply functions to a specific subset of data

rvdata%>%select(YEAR,COMM,TOTWGT,TOTNO)%>%group_by(YEAR)

## summarise ----------- summarise data down to a specified range

rvdata%>%summarise(mn=mean(TOTWGT,na.rm=T),
                   sd=sd(TOTWGT,na.rm=T))

rvdata%>%
  group_by(YEAR)%>%
  summarise(mn=mean(TOTWGT,na.rm=T),
            sd=sd(TOTWGT,na.rm=T))

rvdata%>%mutate(DIST = sample(x=seq(from= 1,to = 3,by=0.01),size=n(),replace=T),
                STDWGT = TOTWGT*1.75/DIST)%>%
  filter(YEAR %in% 2013:2016)%>%
  plot(STDWGT~TOTWGT,data=.)

rvdata%>%
  filter(species %in% c("AMERICAN LOBSTER","COD(ATLANTIC)"),XTYPE==1)%>%
  rename(species=species)%>%
  group_by(YEAR,species)%>%
  sample_frac(0.5)%>%
  mutate(aWGT=TOTWGT/TOTNO)%>%
  summarise(mn=mean(aWGT,na.rm=T),
            sd=sd(aWGT,na.rm=T))%>%data.frame()

#without dplyr ** there are many ways to do this **
    tempdata=rvdata
    colnames(tempdata)[grep("COMM",colnames(tempdata))]="species"
    tempdata <- tempdata[tempdata$species %in% c("AMERICAN LOBSTER","COD(ATLANTIC)") & tempdata$XTYPE == 1,]
    tempdata$aWGT <- tempdata$TOTWGT/tempdata$TOTNO
     
    output=NULL
    for(y in unique(tempdata$YEAR)){            
      for(i in c("AMERICAN LOBSTER","COD(ATLANTIC)")){
      
      tempind <- which(tempdata$species==i & tempdata$YEAR == y)
      hold <- tempdata[sample(tempind,length(tempind)/2,replace=F),"aWGT"]
      output <- rbind(output,data.frame(YEAR=y,species=i,mn=mean(hold,na.rm=T),sd=sd(hold,na.rm=T),stringsAsFactors = F))
      
      }
    }  
                    

## Calculate diversity -------------- Test application

rvdata%>%filter(XTYPE==1)%>%arrange(MISSION,SETNO,TOTNO)%>%head(.,20) #see that each species has a single row within a set

diversity <- rvdata%>%
             filter(XTYPE==1)%>%
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
            
#make a basic map of data from 2015:2018 of proportional fish and invertebrate diversity                                                                            
makemap(diversity%>%filter(between(YEAR,2015,2018),!is.na(pdiv))%>%dplyr::select(LONGITUDE,LATITUDE,pdiv))





