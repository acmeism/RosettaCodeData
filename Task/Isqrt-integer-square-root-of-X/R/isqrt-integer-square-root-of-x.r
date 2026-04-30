isqrt <- function(x){
  q <- 1L
  while(q <= x) q <- q*4L
  z <- as.integer(x)
  r <- 0L
  while(q > 1){
    q <- q%/%4L
    t <- z-r-q
    r <- r%/%2L
    if(t >= 0){
      z <- t
      r <- r+q
    }
  }
  return(r)
}

options(width=40)
sapply(0:65, isqrt)
cat(sapply(7^(2*(1:5)-1), isqrt), sep="\n")
