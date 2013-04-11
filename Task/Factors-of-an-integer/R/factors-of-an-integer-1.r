factors <- function(n)
{
   if(length(n) > 1)
   {
      lapply(as.list(n), factors)
   } else
   {
      one.to.n <- seq_len(n)
      one.to.n[(n %% one.to.n) == 0]
   }
}
factors(60)
