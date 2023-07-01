library(bit64)
popCount <- function(x) sum(as.numeric(strsplit(as.bitstring(as.integer64(x)), "")[[1]]))
finder <- function()
{
  odious <- evil <- integer(0)
  x <- odiousLength <- evilLength <- 0
  while(evilLength + odiousLength != 60)#We could be smarter, but this condition suffices.
  {
    if(popCount(x) %% 2 == 0) evil[evilLength + 1] <- x else odious[odiousLength + 1] <- x
    x <- x + 1
    evilLength <- length(evil)
    odiousLength <- length(odious)
  }
  cat("The pop count of the 1st 30 powers of 3 are:", sapply(3^(0:29), popCount), "\n")
  cat("The first 30 evil numbers are:", evil, "\n")
  cat("The first 30 odious numbers are:", odious)
}
finder()
