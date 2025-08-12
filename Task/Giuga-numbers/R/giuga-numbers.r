library(gmp)

isgiuga <- function(n){
  facs <- unique(factorize(n))
  all((n/facs-1)%%facs==0)
}

count <- 0
n <- 4
while(count<4){
  if(isgiuga(n)){
    print(n)
    count <- count+1
  }
  n <- n+2
}
