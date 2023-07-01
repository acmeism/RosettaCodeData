genFizzBuzz <- function(n, ...)
{
  args <- list(...)
  #R doesn't like vectors of mixed types, so c(3, "Fizz") is coerced to c("3", "Fizz"). We must undo this.
  #Treating "[[" as if it is a function is a bit of R's magic. You can treat it like a function because it actually is one.
  factors <- as.integer(sapply(args, "[[", 1))
  words <- sapply(args, "[[", 2)
  sortedPermutation <- sort.list(factors)#Required by the task: We must go from least factor to greatest.
  factors <- factors[sortedPermutation]
  words <- words[sortedPermutation]
  for(i in 1:n)
  {
    isFactor <- i %% factors == 0
    print(if(any(isFactor)) paste0(words[isFactor], collapse = "") else i)
  }
}
genFizzBuzz(105, c(3, "Fizz"), c(5, "Buzz"), c(7, "Baxx"))
genFizzBuzz(105, c(5, "Buzz"), c(9, "Prax"), c(3, "Fizz"), c(7, "Baxx"))
