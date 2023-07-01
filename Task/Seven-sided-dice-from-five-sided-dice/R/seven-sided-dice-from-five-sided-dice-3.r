dice7.vec <- function(n=1, checkLength=TRUE)
{
   morethan2n <- 3 * n + 10 + (n %% 2)       #need more than 2*n samples, because some are discarded
   twoDfive <- matrix(dice5(morethan2n), nrow=2)
   total <- colSums(c(5, 1) * twoDfive) - 3
   score <- ifelse(total < 24, total %/% 3, NA)
   score <- score[!is.na(score)]
   #If length is less than n (very unlikely), add some more samples
   if(checkLength)
   {
      while(length(score) < n)
      {
         score <- c(score, dice7(n, FALSE))
      }
      score[1:n]
   } else score
}
system.time(dice7.vec(1e6))   # ~1 sec
