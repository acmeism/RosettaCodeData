namedNums <- c(Fizz = 3, Buzz = 5)
for(i in 1:100)
{
  isFactor <- i %% namedNums == 0
  print(if(any(isFactor)) paste0(names(namedNums)[isFactor], collapse = "") else i)
}
