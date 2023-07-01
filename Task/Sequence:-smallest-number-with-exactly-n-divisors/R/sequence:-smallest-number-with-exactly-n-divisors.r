#Need to add 1 to account for skipping n. Not the most efficient way to count divisors, but quite clear.
divisorCount <- function(n) length(Filter(function(x) n %% x == 0, seq_len(n %/% 2))) + 1
smallestWithNDivisors <- function(n)
{
  i <- 1
  while(divisorCount(i) != n) i <- i + 1
  i
}
print(sapply(1:15, smallestWithNDivisors))
