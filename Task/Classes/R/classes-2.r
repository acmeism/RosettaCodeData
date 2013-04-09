setClass("circle",
   representation(
      radius="numeric",
      centre="numeric"),
   prototype(
      radius=1,
      centre=c(0,0)))
#Instantiate class with some arguments
circS4 <- new("circle", radius=5.5)
#Set other data slots (properties)
circS4@centre <- c(3,4.2)

#Define a method
setMethod("plot", #signature("circle"),
   signature(x="circle", y="missing"),
   function(x, ...)
   {
      t <- seq(0, 2*pi, length.out=200)
      #Note the use of @ instead of $
      plot(x@centre[1] + x@radius*cos(t),
         x@centre[2] + x@radius*sin(t),
         type="l", ...)
   })
plot(circS4)
