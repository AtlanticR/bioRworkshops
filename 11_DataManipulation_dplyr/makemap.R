

makemap <- function(xyz){
  
  #xyz - data to be plotted either in two (long, lat) or three column format (long,lat,z). values should be in 
  #decimal degrees (i.e., -degrees West)
  
  require(ggplot2)
  require(mapdata)
  require(maptools)
  
  #check to see that the longitude and latitude values are in order
  if(sign(xyz[1,2])<0 & length(xyz)==2){xyz <- xyz[,c(2,1)]}
  if(sign(xyz[1,2])<0 & length(xyz)==3){xyz <- xyz[,c(2,1,3)]}
  
  if(length(xyz)==2){colnames(xyz) <- c("x","y")} else {colnames(xyz) <- c("x","y","z")}
 
#read in map data  
  states <- map_data("state")
  usa <- subset(states,region == "maine")
  canada <- map_data("worldHires", "Canada")
  
  p1 <- ggplot() +
    geom_polygon(data = usa, 
                 aes(x=long, y = lat, group = group), 
                 fill = "white", 
                 color="black") +
    geom_polygon(data = canada, aes(x=long, y = lat, group = group), 
                 fill = "white", color="black") + 
    coord_fixed(xlim = c(-68.25,-54.8), ylim = c(39.9,47.9), ratio = 1.2)+
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