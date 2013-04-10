closestPair<-function(x,y)
  {
  distancev <- function(pointsv)
    {
    x1 <- pointsv[1]
    y1 <- pointsv[2]
    x2 <- pointsv[3]
    y2 <- pointsv[4]
    sqrt((x1 - x2)^2 + (y1 - y2)^2)
    }
  pairstocompare <- t(combn(length(x),2))
  pointsv <- cbind(x[pairstocompare[,1]],y[pairstocompare[,1]],x[pairstocompare[,2]],y[pairstocompare[,2]])
  pairstocompare <- cbind(pairstocompare,apply(pointsv,1,distancev))
  minrow <- pairstocompare[pairstocompare[,3] == min(pairstocompare[,3])]
  if (!is.null(nrow(minrow))) {print("More than one point at this distance!"); minrow <- minrow[1,]}
  cat("The closest pair is:\n\tPoint 1: ",x[minrow[1]],", ",y[minrow[1]],
                          "\n\tPoint 2: ",x[minrow[2]],", ",y[minrow[2]],
                          "\n\tDistance: ",minrow[3],"\n",sep="")
  c(distance=minrow[3],x1.x=x[minrow[1]],y1.y=y[minrow[1]],x2.x=x[minrow[2]],y2.y=y[minrow[2]])
  }
