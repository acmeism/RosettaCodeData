selectionsort.rec <- function(x)
{
   if(length(x) > 1)
   {
      mini <- which.min(x)
      c(x[mini], selectionsort(x[-mini]))
   } else x
}
