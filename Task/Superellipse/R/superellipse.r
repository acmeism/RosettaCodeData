superellipse <- function(x,y) abs(x/200)^(2.5)+abs(y/200)^(2.5)-1
x <- y <- seq(from=-200, to=200, length.out=1000)
z <- outer(x, y, superellipse)
png(filename="Superellipse-R.png", width=1000, height=1000)
contour(x, y, z, levels=0)
dev.off()
