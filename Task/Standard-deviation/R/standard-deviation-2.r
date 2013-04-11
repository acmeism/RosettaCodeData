#Again, if na.rm is true, missing data points (NA values) are removed.
 uncorrectedsd <- function(x, na.rm=FALSE)
 {
   len <- length(x)
   if(len < 2) stop("2 or more data points required")
   mu <- mean(x, na.rm=na.rm)
   ssq <- sum((x - mu)^2, na.rm=na.rm)
   usd <- sqrt(ssq/len)
   usd
 }
 uncorrectedsd(testdata) #2
