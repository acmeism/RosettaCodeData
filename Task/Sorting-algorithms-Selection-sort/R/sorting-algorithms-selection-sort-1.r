selectionsort.loop <- function(x)
{
   lenx <- length(x)
   for(i in seq_along(x))
   {
      mini <- (i - 1) + which.min(x[i:lenx])
      start_ <- seq_len(i-1)
      x <- c(x[start_], x[mini], x[-c(start_, mini)])
   }
   x
}
