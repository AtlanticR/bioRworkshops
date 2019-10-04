# function that integrates basic mapping code from the bioRworkshops session 12.

makemap <- function(xyz,bathy=FALSE,breaks=c(-200,-3000),facet=NULL,zlab="",nrow=1){
  
  #xyz - data to be plotted either in two (long, lat) or three column format (long,lat,z). values should be in 
  #decimal degrees (i.e., -degrees West)
  #bathy - do you want a bathymetry contour
  #breaks for the countour - default at 200m and 3 km
  #facet is a vector of the same length as xyz that can be used for facetting
  #nrow is the number of rows wanted (for facetting) - default is 2
  
  require(ggplot2)
  require(mapdata)
  require(maptools)
  require(marmap)
  
  #check to see that the longitude and latitude values are in order
  if(sign(xyz[1,2])<0 & length(xyz)==2){xyz <- xyz[,c(2,1)]}
  if(sign(xyz[1,2])<0 & length(xyz)==3){xyz <- xyz[,c(2,1,3)]}
  
  if(length(xyz)==2){colnames(xyz) <- c("x","y")} else {colnames(xyz) <- c("x","y","z")}
  
  if(!is.null(facet)){xyz <- cbind(xyz,facet)
                      colnames(xyz)[length(xyz)] = "facet"}
 
  
  #datalimits
  Lat.lim <- c(min(xyz$y,na.rm=T)-0.2,max(xyz$y,na.rm=T)+0.2)
  Long.lim <- c(min(xyz$x,na.rm=T)-0.2,max(xyz$x,na.rm=T)+0.2)
  
#read in map data  
  states <- map_data("state")
  usa <- subset(states,region == "maine")
  canada <- map_data("worldHires", "Canada")
  
  p1 <- ggplot() +
    geom_polygon(data = usa, 
                 aes(x=long, y = lat, group = group), 
                 fill = "grey50") +
    geom_polygon(data = canada, aes(x=long, y = lat, group = group), 
                 fill = "grey50") + 
    coord_fixed(xlim = Long.lim, ylim = Lat.lim, ratio = 1.2)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill = "white", colour = "black"),
          plot.background = element_rect(colour = "white"),
          strip.background = element_rect(colour = "black", fill = "white"))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")))
  
  if(length(xyz)==2){p1 <- p1+geom_point(data=xyz,aes(x=x,y=y),pch=19)}
  if(length(xyz)>2){p1 <- p1+geom_point(data=xyz,aes(x=x,y=y,size=z))+
    theme(legend.position="bottom")+ 
    scale_size(range = c(0, 3))+labs(size=zlab)}
  
  
  if(bathy){
    
    #datalimits
    Lat.lim <- c(min(xyz$y,na.rm=T)-0.2,max(xyz$y,na.rm=T)+0.2)
    Long.lim <- c(min(xyz$x,na.rm=T)-0.2,max(xyz$x,na.rm=T)+0.2)
    
    #Lets add bathymetry 
    bathy <-getNOAA.bathy(Long.lim[1],Long.lim[2],Lat.lim[1],Lat.lim[2],res=1,keep=T)
    
    #convert to a dataframe so ggplot can plot it
    bathy.df <- fortify(bathy)
    
    p1 <- p1+ geom_contour(data=bathy.df,
                           aes(x=x,y=y,z=z),
                           breaks=breaks,
                           colour="black", size=0.1)
    
  }
  
  if(!is.null(facet)){
    p1 <- p1+facet_wrap(~facet,nrow=nrow)
  }
  
  
  return(p1)
}