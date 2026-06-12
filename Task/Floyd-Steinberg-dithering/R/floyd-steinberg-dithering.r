mpv <- 255
pattern <- function(x, y) mpv*(0.5+0.5*sin(x/100+y/300)*sin(y/100))
pixel <- outer(1:640, 1:480, pattern)

closest_color <- function(x) floor(x/mpv+0.5)*mpv

for(y in 1:480) {
  for(x in 1:640) {
    oldp <- pixel[x, y]
    newp <- closest_color(oldp)
    pixel[x, y] <- newp
    err <- oldp-newp
    if(x < 640 && y < 480) {
      pixel[x+1, y] <- pixel[x+1, y]+err*7/16
      if(x > 1) pixel[x-1, y+1] <- pixel[x+1, y+1]+err*3/16
      pixel[x, y+1] <- pixel[x, y+1]+err*5/16
      pixel[x+1, y+1] <- pixel[x+1, y+1]+err*1/16
    }
  }
}

png(filename="FloydSteinberg-R.png", width=800, height=600)
image(pixel, axes=FALSE)
dev.off()
