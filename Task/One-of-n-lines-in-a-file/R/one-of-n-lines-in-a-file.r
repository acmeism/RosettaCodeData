one_of_n <- function(n)
{
  choice <- 1L

  for (i in 2:n)
  {
    if (i*runif(1) < 1)
      choice <- i
  }

  return(choice)
}

table(sapply(1:1000000, function(i) one_of_n(10)))
