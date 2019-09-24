spPlot_bubble <- function(xyz,NAFO=NULL,binning = c(0,10,50,100),depth=-200,sizes=NULL,facet=NULL,bathy=NULL,
                          extended=FALSE,facetorder=NULL,sizeoffset=2.5,apBubble=1) {
  
  #Plot returns a ggplot object
  #xyz - is the dataframe of interest
  #poly - is a full file path for a shape file the area of interest (default is the shape file for the Fundian in the data/ folder)
  #NAFO - is a full file path for a shape file for the planning region where the data will be gridded. (default is the shape file for the Maritimes Planning region in the data/ folder)
  #facet - variable to facet the data by (this is a grouping variable) (default is NULL, otherwise should be YEAR, BIANNUAL, or DECADAL). 
  #depth - the depth expressed as a negative value for the contour line(s) you wish to plot. Defaults to -200
  #bathy - bathyobject from MARMAP -- if null one will be downloaded to the working directory
  #variable - is the value from the survey (e.g., Total Weight) to be included as a legend title
  #extended - logical specifying whether the plot will extend beyond the usual focus on the maritimes region. specifically to incoporate coastline data for northeastern states beyond Maine.
  #apBubble - transparency of the points - default is non-transparent
  
  #load required libraries
  require(sp)
  require(rgdal)
  require(raster)
  require(shape)
  require(rgeos)
  require(raster)
  require(ggplot2)
  require(mapdata)
  require(marmap)
  require(dplyr)
  
  #Clean up the column names
  #check to see that the longitude and latitude values are in order
  if(sign(xyz[1,2])<0 & length(xyz)==2){xyz <- xyz[,c(2,1)]}
  if(sign(xyz[1,2])<0 & length(xyz)==3){xyz <- xyz[,c(2,1,3)]}
  if(sign(xyz[1,2])<0 & length(xyz)==4){xyz <- xyz[,c(2,1,3,4)]}
  
  if(length(xyz)==2){colnames(xyz) <- c("x","y")} else if (length(xyz)==3){colnames(xyz) <- c("x","y","z")} else if (length(xyz)==4){colnames(xyz) <- c("x","y","z","YEAR")} else print("You have more than four columns, this function only accepts data frams with 2-4 columns")
  
  #Map data for ggplot
  if(is.null(NAFO)){NAFODivisions <- readOGR("NAFO_Divisions/Divisions.shp")}
  if(!is.null(NAFO)){NAFODivisions <- readOGR(NAFO)}
  
  #set to common projection
  NAFODivisions <- spTransform(NAFODivisions,CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  #Set plot binning
  labels <- NULL
  for(i in 1:(length(binning)-1)){
    
    labels <- c(labels,paste(binning[i],binning[i+1],sep="-"))
    
  }
  
  labels <- c(labels,paste0(max(binning),"+"))
  breaks <- as.character(cut(xyz[,3],c(binning,max(xyz[,3],na.rm=T)),labels=labels))
  breaks[xyz$z==0]="0"
  breaks[is.na(breaks)] <- 0 # this will substitute 0's in that don't get captured in the breaking 
  labels=c("0",labels)
  if(is.null(sizes)){sizes<- 0.3}
  plotsizes <- rep(0.3,length(breaks))
  plotcols <- c("grey80",rep("black",4))
  #paste0("grey",rev(seq(from=40,to=100,length.out = length(labels)-1)[1:(length(labels)-2)])),

  for(i in labels[2:length(labels)]){
    
    sizes <- c(sizes,sizes[length(sizes)]+0.5) 
    plotsizes[breaks==i] <- sizes[length(sizes)]
    
  }
  
  ## add extra information for plotting
  xyz$breaks <- factor(breaks,levels=labels)
  
  #Set plotting limits
  tempextent <- xyz
  colnames(tempextent) <- c("Long","Lat","Z")
  coordinates(tempextent) <- c("Long", "Lat")
  proj4string(tempextent) <- CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0") 
  rextent <- extent(tempextent)
  
  #plotting limits
  Long.lim  <-  c(rextent[1], rextent[2])
  Lat.lim <-  c(rextent[3], rextent[4])
  
  #Download bathymetric data
  if(is.null(bathy)){
    if(!dir.exists("data")){dir.create("data/")} #create a data directory if it doesn't exist
    curdir <- getwd()
    setwd("data/")
    bathy <- getNOAA.bathy(Long.lim[1],Long.lim[2],Lat.lim[1],Lat.lim[2],res=1,keep=T)
    setwd(curdir)
  }
  
  #format bathy for ggplot
  bathy <- fortify(bathy)
  
  states <- map_data("state")
  if(!extended){usa <- subset(states,region == "maine")} #just need maine
  
  if(extended){usa <- subset(states,region %in% c("maine","new hampshire",
                                                  "massachusetts","connecticut","rhode island","vermont"))}
  
  canada <- map_data("worldHires", "Canada")
  FortNAFO <- fortify(NAFODivisions)

  #Make the plot
  if(is.null(facet)){
    p1 <- ggplot() +
      geom_polygon(data=FortNAFO,
                   aes(long, lat, group = group),lwd=0.5,fill="white",col="black")+
      geom_polygon(data = usa, 
                   aes(x=long, y = lat, group = group), 
                   fill = "white", 
                   color="black") +
      geom_polygon(data = canada, aes(x=long, y = lat, group = group), 
                   fill = "white", color="black") + 
      geom_contour(data=bathy,aes(x=x,y=y,z=z),breaks=c(depth),lwd=0.05,colour="deepskyblue")+     
      geom_point(data=xyz%>%arrange(breaks),aes(x=x,y=y,size=breaks,col=breaks,shape=breaks),alpha=apBubble)+
      scale_size_manual(values=sizes*sizeoffset)+
      scale_colour_manual(values=plotcols)+
      scale_shape_manual(values=c(20,19,19,19,19))+
      coord_fixed(xlim = Long.lim,  ylim = Lat.lim, ratio = 1.2)+
      theme_bw()+
      theme(legend.position = "bottom",
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            panel.background = element_rect(fill = "white", colour = "black"),
            plot.background = element_rect(colour = "white"),
            strip.background = element_rect(colour = "black", fill = "white"))+
      labs(x=expression(paste("Longitude ",degree,"W",sep="")),
           y=expression(paste("Latitude ",degree,"N",sep="")))
    
    
  }
  
  
  
  if(!is.null(facet)){
    
    if(!is.null(facetorder)){xyz$f <- factor(facet,levels=facetorder)} else {xyz$f=facet}
    
    # to save room we will crop canada before we facet
    # canadabox <- rextent
    # canadabox[1] <- canadabox[1]-1
    # canadabox[4] <- canadabox[4]+4
    # 
    # boundbox <- as(canadabox, 'SpatialPolygons')
    # proj4string(boundbox) <- proj4string(Fundian)
    # 
    # coordinates(canada) <- ~long + lat
    # proj4string(canada) <- proj4string(Fundian)
    # canada <- as(canada,'SpatialPointsDataFrame')
    # ind_canada <- over(canada,boundbox)
    # 
    # #reload and index
    # canada <- map_data("worldHires", "Canada")
    # canada <- canada[!is.na(ind_canada),]
    
    p1 <- ggplot() +
      geom_polygon(data=FortNAFO,
                   aes(long, lat, group = group),fill=NA,lwd=0.5,col="black")+
      #geom_point(data=dplyr::filter(xyz,breaks!="0"),aes(x=x,y=y,col=breaks,shape=breaks),pch=19)+
      geom_polygon(data = usa, 
                   aes(x=long, y = lat, group = group), 
                   fill = "white", 
                   color="black") +
      geom_polygon(data = canada, aes(x=long, y = lat, group = group), 
                   fill = "white", color="black") + 
      geom_contour(data=bathy,aes(x=x,y=y,z=z),breaks=c(depth),lwd=0.05,colour="deepskyblue")+
      geom_point(data=xyz%>%arrange(breaks),aes(x=x,y=y,col=breaks,shape=breaks,size=breaks),alpha=apBubble)+
      scale_size_manual(values=sizes*sizeoffset)+
      scale_colour_manual(values=plotcols)+
      scale_shape_manual(values=c(20,19,19,19,19))+
      coord_fixed(xlim = Long.lim,  ylim = Lat.lim, ratio = 1.2)+
      theme_bw()+
      theme(legend.position = "bottom",
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            panel.background = element_rect(fill = "white", colour = "black"),
            plot.background = element_rect(colour = "white"),
            strip.background = element_rect(colour = "black", fill = "white"))+
      labs(x=expression(paste("Longitude ",degree,"W",sep="")),
           y=expression(paste("Latitude ",degree,"N",sep="")))+
      facet_wrap(~YEAR)
    
    
  } 
  
  #return the plot back
  return(p1)
  
  
} # end of function