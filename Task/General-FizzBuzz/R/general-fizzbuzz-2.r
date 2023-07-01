namedGenFizzBuzz <- function(n, namedNums)
{
  factors <- sort(namedNums)#Required by the task: We must go from least factor to greatest.
  for(i in 1:n)
  {
    isFactor <- i %% factors == 0
    print(if(any(isFactor)) paste0(names(factors)[isFactor], collapse = "") else i)
  }
}
namedNums <- c(Fizz=3, Buzz=5, Baxx=7)#Notice that we can name our inputs without a function call.
namedGenFizzBuzz(105, namedNums)
shuffledNamedNums <- c(Buzz=5, Prax=9, Fizz=3, Baxx=7)
namedGenFizzBuzz(105, shuffledNamedNums)
