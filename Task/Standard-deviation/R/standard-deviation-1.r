#The built-in standard deviation function applies the Bessel correction.  To reverse this, we can apply an uncorrection.
#If na.rm is true, missing data points (NA values) are removed.
 reverseBesselCorrection <- function(x, na.rm=FALSE)
 {
   if(na.rm) x <- x[!is.na(x)]
   len <- length(x)
   if(len < 2) stop("2 or more data points required")
   sqrt((len-1)/len)
 }
 testdata <- c(2,4,4,4,5,5,7,9)
 reverseBesselCorrection(testdata)*sd(testdata) #2
