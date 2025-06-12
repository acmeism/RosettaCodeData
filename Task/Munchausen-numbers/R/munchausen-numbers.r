exp_digsum <- function(n){
  if(n>9){
    return((n%%10)^(n%%10)+exp_digsum(n%/%10))
  }
  else return(n^n)
}

for(i in 1:5000){
  if(exp_digsum(i)==i) print(i)
}
