## Maps with ggplot -----------
# R noobs session 

#Ryan Stanley

##Load Libraries
library(ggplot2) #graphical plotting - based on data frames
library(maps) #basic mapping packages with useful spatial data (i.e., bounding polygons, land, coastlines, etc)
library(mapdata) #even more mapping data
library(marmap) #package to get bathymetric data
library(dplyr) #data manipulation package
library(tidyr) #package with extended data manipulation in addition to dplyr
library(ggsn) #package that permits scale bars in ggplot

## Get data for later plotting ---------
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


#Use ggplot to extract mapping data from the mapdata package and format into a dataframe that can be plotted
Canada <- map_data("worldHires", "Canada") #high resolution map of Canada

glimpse(Canada)

#Group is an important aspect of the dataframe that map_data has created from the highresolution coastline. This variable
#helps to define whether points should be connected by lines 

p1 <- ggplot() +
  geom_polygon(data = Canada, aes(x=long, y = lat, group = group)) + 
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
       y=expression(paste("Latitude ",degree,"N",sep="")))
p1

p1+coord_fixed(1.5)

#ggplot is a database plotting program and is not a mapping program specifically. Therefore
#when plotting it treats the x (longitude) and y (latitude) like any other bivariate relationship
#that you might use. This limitation means that by default the latitude and longitude values
#are treated as if they are planar coordinates and thus you must specify a ratio that works 
#for the region. In this case 1.5 looks ok and it means that every unit of latitude is ~1.5 times
#longer than every unit of latitude. As you zoom in and particularily when you go to the poles this ratio
#must change. However, this ratio is important becausae it will maintain that relationship not matter
#how the plot is scaled. 

#you can apply standard issue ggplot fill and colour variables to change the look of the plot

ggplot() +
  geom_polygon(data = Canada, aes(x=long, y = lat, group = group),fill="red",colour="green") + 
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
       y=expression(paste("Latitude ",degree,"N",sep="")))+
  theme_bw()


#Islands of Canada are partitioned by groups, otherwise Canada is treated as a large polygon. 

PEI <- Canada%>%filter(subregion == "Prince Edward Island")

ggplot() +
  geom_polygon(data = PEI, aes(x=long, y = lat, group = group),fill="palegreen",colour="black") + 
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
       y=expression(paste("Latitude ",degree,"N",sep="")))+
  theme_bw()+
  coord_fixed(1.2)

# We can used coord_fixed to zoom in on a specific area of Canada

Lat.lim <- c(min(plotdata$lat,na.rm=T)-0.2,max(plotdata$lat,na.rm=T)+0.2)
Long.lim <- c(min(plotdata$long,na.rm=T)-0.2,max(plotdata$long,na.rm=T)+0.2)

ns <- ggplot() +
  geom_polygon(data = Canada, aes(x=long, y = lat, group = group),fill="grey50",colour="black") + 
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
       y=expression(paste("Latitude ",degree,"N",sep="")))+
  theme_bw()+
  coord_fixed(1.2,xlim=Long.lim,ylim = Lat.lim)

ns

#hmm NB is looking lonely. Here we only have Canada so lets get the US and plot it as well

USA <- map_data("state")

ns <- ns+geom_polygon(data = USA, aes(x=long, y = lat, group = group),fill="grey50",colour="black")

#Looks better. Now lets add data layers

ns+geom_point(data=plotdata,aes(x=long,y=lat))


#Lets trim this for some specific species

ns+geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER",YEAR %in% 2014:2016),
              aes(x=long,y=lat))

ns+geom_point(data=filter(plotdata,species=="COD(ATLANTIC)",YEAR %in% 2014:2016),
              aes(x=long,y=lat))

#You can even facet for species
ns+geom_point(data=filter(plotdata,YEAR %in% 2014:2016),
              aes(x=long,y=lat))+
  facet_grid(~species)

#or facet for year
ns+geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER",YEAR %in% 2014:2016),
              aes(x=long,y=lat))+
  facet_grid(~YEAR)

#why not both? 
ns+geom_point(data=filter(plotdata,YEAR %in% 2014:2016),
              aes(x=long,y=lat,col=factor(YEAR)))+
  facet_grid(~species) #facet by species here so points don't overlap

#Lobster over the years
ns+geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER"),
              aes(x=long,y=lat))+
  facet_wrap(~YEAR,nrow=3)

#is there actually more sets with lobster?
lobsum <- plotdata%>%
  filter(species=="AMERICAN LOBSTER")%>%
  group_by(YEAR)%>%
  summarise(numsets=n(),
            mass=sum(wgt,na.rm=T))%>%
  ungroup()%>%
  gather(variable,value,-YEAR)%>%
  data.frame()

ggplot(data=lobsum,aes(x=YEAR,y=value))+
    geom_line()+
    geom_point(size=3)+
    theme_bw()+
    facet_wrap(~variable,nrow=2,scales="free_y")+
    labs(x="Year",y="Number of sets with lobster")

#Clearly biomass has a positive trend with time. Lets plot this

ns+geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER",YEAR %in% 2014:2016),
              aes(x=long,y=lat,size=wgt))+
  labs(size="Total weight (kg)")+
  facet_wrap(~YEAR,nrow=1)

#lots of overlap == lets use it
ns+geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER",YEAR %in% c(2010,2017)),
              aes(x=long,y=lat,size=wgt),alpha=0.5)+
  labs(size="Total weight (kg)")+
  facet_wrap(~YEAR,nrow=1)
  
lobplot <- ns+geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER",YEAR %in% c(2010,2017)),
              aes(x=long,y=lat,size=wgt),alpha=0.5)+
  labs(size="Total weight (kg)")+
  facet_wrap(~YEAR,nrow=1)+
  scale_size(range=c(1,5))

lobplot


#Lets add bathymetry 
bathy <-getNOAA.bathy(Long.lim[1],Long.lim[2],Lat.lim[1],Lat.lim[2],res=1,keep=F)

#convert to a dataframe so ggplot can plot it
bathy.df <- fortify(bathy)

bplot <- ggplot()+
  geom_raster(data=filter(bathy.df,z <= 0),aes(x=x,y=y,fill=z)) +
  geom_raster(data=filter(bathy.df,z > 0),aes(x=x,y=y),fill="grey50")+
  geom_contour(data=bathy.df,
               aes(x=x,y=y,z=z),
               breaks=c( -200, -1000, -4000),
               colour="black", size=0.1)+
  coord_fixed(1.2,xlim=Long.lim,ylim = Lat.lim)+
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0)) ## gives warnings

#lets add poitns
bplot+
  geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER",YEAR %in% c(2010,2017)),
                 aes(x=long,y=lat,size=wgt),alpha=0.5)+
  facet_wrap(~YEAR,nrow=1)

lobplot <- lobplot +  geom_contour(data=bathy.df,
                        aes(x=x,y=y,z=z),
                        breaks=c( -250, -2500),
                        colour="black", size=0.1)



#Add a scale bar
ns+geom_point(data=filter(plotdata,species=="AMERICAN LOBSTER",YEAR %in% c(2010,2017)),
              aes(x=long,y=lat,size=wgt),alpha=0.5)+
  labs(size="Total weight (kg)")+
  facet_wrap(~YEAR,nrow=1)+
  scale_size(range=c(1,5))+
  scalebar(plotdata,
                 location="bottomright",
                       dist = 100,
                       dist_unit = "km",
                       transform=TRUE,
                       model = 'WGS84',
                       facet.var = 'YEAR',
                      facet.lev = 2017, #only in the 2017 facet
                       st.dist = .025,
                      st.size=3,
                      height = 0.015)


## Fancy diversity map

library(gridExtra) #for making ggplot insets

MainPlot <- ggplot() +
  geom_polygon(data = Canada, aes(x=long, y = lat, group = group),fill="grey50",colour="black") + 
  geom_polygon(data = USA, aes(x=long, y = lat, group = group),fill="grey50",colour="black")+
  geom_contour(data=bathy.df,
               aes(x=x,y=y,z=z),
               breaks=c( -250, -3500),
               colour="black", size=0.1)+
  geom_point(data=filter(diversity,year ==2017),
              aes(x=long,y=lat,size=div),alpha=0.5)+
  geom_rect(aes(xmin=-67.3,xmax=-65.7,ymin=41,ymax=42.4), 
            alpha=0, colour="black", size = 1, linetype=1)+
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
       y=expression(paste("Latitude ",degree,"N",sep="")),
       size="Species richness")+
  theme_bw()+
  theme(legend.position="bottom")+
  coord_fixed(1.2,xlim=Long.lim,ylim = Lat.lim)+
  scale_size(range=c(1,5))

SubPlot <- ggplot()+
            geom_contour(data=bathy.df,
                       aes(x=x,y=y,z=z),
                       breaks=c( -250, -3500),
                       colour="black", size=0.1)+
           geom_point(data=filter(diversity,year ==2017),
             aes(x=long,y=lat,size=div),alpha=0.5)+
           theme_bw()+
           scale_size(range=c(1,10))+
        coord_fixed(1.2,xlim=c(-67.3,-65.7),ylim = c(41,42.5))+
          scale_x_continuous(expand=c(0,0))+
          scale_y_continuous(expand=c(0,0))+
          theme(axis.text = element_blank(),
                axis.title = element_blank(),
                axis.ticks = element_blank(),
                legend.position = "none")

png(file="mrdq.png",w=1800,h=1800, res=300)
grid.newpage()
v1<-viewport(width = 1, height = 1, x = 0.5, y = 0.5) #plot area for the main map
v2<-viewport(width = 0.2, height = 0.2, x = 0.88, y = 0.39) #plot area for the inset map
print(MainPlot,vp=v1) 
print(SubPlot,vp=v2)
dev.off()


