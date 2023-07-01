dice7.while <- function(n=1)
{
   score <- numeric()
   while(length(score) < n)
   {
      total <- sum(c(5,1) * dice5(2)) - 3
      if(total < 24) score <- c(score, total %/% 3)
   }
   score
}
system.time(dice7.while(1e6)) # longer than 4 minutes
