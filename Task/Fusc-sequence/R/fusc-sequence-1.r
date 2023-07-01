firstNFuscNumbers <- function(n)
{
  stopifnot(n > 0)
  if(n == 1) return(0) else fusc <- c(0, 1)
  if(n > 2)
  {
    for(i in seq(from = 3, to = n, by = 1))
    {
      fusc[i] <- if(i %% 2) fusc[(i + 1) / 2] else fusc[i / 2] + fusc[(i + 2) / 2]
    }
  }
  fusc
}
first61 <- firstNFuscNumbers(61)
cat("The first 61 Fusc numbers are:", "\n", first61, "\n")
