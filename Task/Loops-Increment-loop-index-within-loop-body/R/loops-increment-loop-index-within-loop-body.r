i <- 42
primeCount <- 0
while(primeCount < 42)
{
  if(gmp::isprime(i) == 2)#1 means "probably prime" and won't come up for numbers this small, 2 is what we want.
  {
    primeCount <- primeCount + 1
    extraCredit <- format(i, big.mark=",", scientific = FALSE)
    cat("Prime count:", paste0(primeCount, ";"), "The prime just found was:", extraCredit, "\n")
    i <- i + i#This is missing the -1 from the Kotlin solution. There is no need to check i + i (it's even).
  }
  i <- i + 1
}
