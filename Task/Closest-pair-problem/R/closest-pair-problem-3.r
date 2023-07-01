closest.pairs <- function(x, y=NULL, ...){
      # takes two-column object(x,y-values), or creates such an object from x and y values
       if(!is.null(y))  x <- cbind(x, y)

       distances <- dist(x)
        min.dist <- min(distances)
          point.pair <- combn(1:nrow(x), 2)[, which.min(distances)]

     cat("The closest pair is:\n\t",
      sprintf("Point 1: %.3f, %.3f \n\tPoint 2: %.3f, %.3f \n\tDistance: %.3f.\n",
        x[point.pair[1],1], x[point.pair[1],2],
          x[point.pair[2],1], x[point.pair[2],2],
            min.dist),
            sep=""   )
     c( x1=x[point.pair[1],1],y1=x[point.pair[1],2],
        x2=x[point.pair[2],1],y2=x[point.pair[2],2],
        distance=min.dist)
     }
