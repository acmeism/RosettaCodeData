#You define a class simply by setting the class attribute of an object
circS3 <- list(radius=5.5, centre=c(3, 4.2))
class(circS3) <- "circle"

#plot is a generic function, so we can define a class specific method by naming it plot.classname
plot.circle <- function(x, ...)
{
   t <- seq(0, 2*pi, length.out=200)
   plot(x$centre[1] + x$radius*cos(t),
      x$centre[2] + x$radius*sin(t),
      type="l", ...)
}
plot(circS3)
