collatz_isself <- function(n){
  init <- n
  while(n > 1){
    ifelse(n%%2 == 0,
           eval(n <- n/2),
           eval(n <- 3*n+1))
    if(n%%init == 0) return(TRUE)
  }
  return(FALSE)
}

count <- 0
num <- 1
while(count < 6){
  if(collatz_isself(num)){
    count <- count+1
    cat(num, "\n")
  }
  num <- num+2
}
