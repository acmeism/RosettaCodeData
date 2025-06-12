cuboid <- function(w, h, d){
  plot(x=NA, xlim=c(0,(w+d)*sqrt(3)/2), ylim=c(0,h+(w+d)/2), xlab=NA, ylab=NA, asp=1)
  polygon(x=c(0, w*sqrt(3)/2, w*sqrt(3)/2, 0),
          y=c(w/2, 0, h, h+w/2),
          col="red")
  polygon(x=c(0, w*sqrt(3)/2, (w+d)*sqrt(3)/2, d*sqrt(3)/2),
          y=c(h+w/2, h, h+d/2, h+(w+d)/2),
          col="blue")
  polygon(x=c(w*sqrt(3)/2, (w+d)*sqrt(3)/2, (w+d)*sqrt(3)/2, w*sqrt(3)/2),
          y=c(0, d/2, h+d/2, h),
          col="yellow")
}

cuboid(2, 3, 4)
