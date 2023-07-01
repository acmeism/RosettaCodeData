tau <- function(t)
{
  results <- integer(0)
  resultsCount <- 0
  n <- 1
  while(resultsCount != t)
  {
    condition <- function(n) (n %% length(c(Filter(function(x) n %% x == 0, seq_len(n %/% 2)), n))) == 0
    if(condition(n))
    {
      resultsCount <- resultsCount + 1
      results[resultsCount] <- n
    }
    n <- n + 1
  }
  results
}
tau(100)
