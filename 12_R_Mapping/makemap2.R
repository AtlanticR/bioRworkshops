

makemap2 <- function(xyz,depth){
  
  #xyz - data to be plotted either in two (long, lat) or three column format (long,lat,z). values should be in 
  #decimal degrees (i.e., -degrees West)
  #depth - the depth contour(s) expressed as a negative value to be plotted on the map
  
  require(ggplot2)
  require(mapdata)
  require(maptools)
  require(raster)
  
  #check to see that the longitude and latitude values are in order
  if(sign(xyz[1,2])<0 & length(xyz)==2){xyz <- xyz[,c(2,1)]}
  if(sign(xyz[1,2])<0 & length(xyz)==3){xyz <- xyz[,c(2,1,3)]}
  if(sign(xyz[1,2])<0 & length(xyz)==4){xyz <- xyz[,c(2,1,3,4)]}
  
  if(length(xyz)==2){colnames(xyz) <- c("x","y")} else if (length(xyz)==3){colnames(xyz)<-c("x","y","z")} else {colnames(xyz) <- c("x","y","z","YEAR")}
    
 
#Break up z data into bins  
  
#read in map data  
  states <- map_data("state")
  usa <- subset(states,region == "maine")
  canada <- map_data("worldHires", "Canada")
  
#Add bathymetry data
  bathyextent<-extent(xyz)
  bathydat<-getNOAA.bathy(bathyextent@xmax,bathyextent@xmin,bathyextent@ymin, bathyextent@ymax, res=1,keep=T)
  bf=fortify.bathy(bathydat)
  
#plot it up  
  p1 <- ggplot() +
    geom_polygon(data = usa, 
                 aes(x=long, y = lat, group = group), 
                 fill = "white", 
                 color="black") +
    geom_polygon(data = canada, aes(x=long, y = lat, group = group), 
                 fill = "white", color="black") + 
    coord_fixed(xlim = c(-68.25,-54.8), ylim = c(39.9,47.9), ratio = 1.2)+
    geom_contour(data=bf,aes(x=x,y=y,z=z),breaks=c(depth),colour="red",size=0.01)+
        theme_bw()+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill = "white", colour = "black"),
          plot.background = element_rect(colour = "white"),
          strip.background = element_rect(colour = "black", fill = "white"))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")))
  
  if(length(xyz)==2){p1 <- p1+geom_point(data=xyz,aes(x=x,y=y),pch=19)}
  if(length(xyz)==3){p1 <- p1+geom_point(data=xyz,aes(x=x,y=y,size=z))+theme(legend.position="none")+ scale_size(range = c(0, 3))}
  
  return(p1)
}