collapse <- function(v){
  while(length(v)>1){
    m1 <- min(v)
    v <- v[-which.min(v)]
    m2 <- min(v)
    v <- v[-which.min(v)]
    v <- c(v, m1+m2)
    print(v)
  }
}

collapse(c(6, 81, 243, 14, 25, 49, 123, 69, 11))
