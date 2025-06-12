fact_digsum <- function(n, b){
  if(n>b-1){
    return(factorial(n%%b)+fact_digsum(n%/%b, b))
  }
  else return(factorial(n))
}

for(i in 9:12){
  cat("Factorions in base",i,"\n")
  for(j in 1:1499999){
    if(j==fact_digsum(j, i)){
      print(j)
    }
  }
}
