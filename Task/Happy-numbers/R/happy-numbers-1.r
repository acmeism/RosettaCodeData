is.happy <- function(n)
{
   stopifnot(is.numeric(n) && length(n)==1)
   getdigits <- function(n)
   {
      as.integer(unlist(strsplit(as.character(n), "")))
   }
   digits <- getdigits(n)
   previous <- c()
   repeat
   {
      sumsq <- sum(digits^2, na.rm=TRUE)
      if(sumsq==1L)
      {
         happy <- TRUE
         break
      } else if(sumsq %in% previous)
      {
         happy <- FALSE
         attr(happy, "cycle") <- previous
         break
      } else
      {
         previous <- c(previous, sumsq)
         digits <- getdigits(sumsq)
      }
   }
   happy
}
