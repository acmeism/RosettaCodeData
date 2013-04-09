fisheryatesshuffle <- function(n)
{
  pool <- seq_len(n)
  a <- c()
  while(length(pool) > 0)
  {
     k <- sample.int(length(pool), 1)
     a <- c(a, pool[k])
     pool <- pool[-k]
  }
  a
}
