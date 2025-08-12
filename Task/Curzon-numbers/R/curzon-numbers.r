library(gmp)

first50curzons <- function(k){
  n <- 1
  big_k <- as.bigz(k)
  curzons <- numeric(0)
  while(length(curzons)<50){
    if(denominator((1+big_k^n)/(1+big_k*n))==1){
      curzons <- c(curzons, n)
    }
    n <- n+1
  }
  return(curzons)
}

curzons_list <- lapply(2*(1:5), first50curzons)
names(curzons_list) <- sapply(2*(1:5), function(k) paste("Base", k))
print(curzons_list)
