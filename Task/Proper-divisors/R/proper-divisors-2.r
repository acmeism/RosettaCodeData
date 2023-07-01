#Task 1
properDivisors <- function(N) Filter(function(x) N %% x == 0, seq_len(N %/% 2))

#Task 2
Vectorize(properDivisors)(1:10)

#Task 3
#Although there are two, the task only asks for one suitable number so that is all we give.
#Similarly, we have seen no need to make sure that "divisors" is only a plural when it should be.
#Be aware that this solution uses both length and lengths. It would not work if the index of the
#desired number was not also the number itself. However, this is always the case.
mostProperDivisors <- function(N)
{
  divisorList <- Vectorize(properDivisors)(seq_len(N))
  numberWithMostDivisors <- which.max(lengths(divisorList))
  paste0("The number with the most proper divisors between 1 and ", N,
        " is ", numberWithMostDivisors,
        ". It has ", length(divisorList[[numberWithMostDivisors]]),
        " proper divisors.")
}
mostProperDivisors(20000)
