#Vectorisation lets you avoid casting to a string and back
digits <- function(n){
  #This task only requires handling numbers up to 3 digits
  dv <- (n%/%c(100,10,1))%%10
  while(dv[1]==0) dv <- dv[-1]
  return(dv)
}

#Make a custom divisibility operator because why not
`%|%` <- function(a, b) b%%a==0

div_cond <- function(n){
  dv <- digits(n)
  all(dv%|%n)&!(prod(dv)%|%n)
}

Filter(div_cond, 1:999)
