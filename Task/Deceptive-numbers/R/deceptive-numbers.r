library(gmp)

repunit <- function(n) as.bigz(strrep("1", n))

n <- 9
count <- 0
while(count<50){
  if(repunit(n-1)%%n==0){
    if(isprime(n)==0){
      count <- count+1
      cat(n, "", rep("\n", count%%10==0))
    }
  }
  n <- n+2
}
