romberg <- function(f, lower, upper, steps, acc){
  h_0 <- upper-lower
  s_0 <- f(upper)+f(lower)
  r <- matrix(data=0, nrow=steps+1, ncol=steps+1)
  r[1,1] <- s_0*h_0/2
  rr <- 0
  n <- 1
  for(i in 1:steps){
    ro <- rr
    n <- 2*n
    h <- h_0/n
    s <- s_0/2
    s <- s+sum(sapply(lower+h*(1:(n-1)), f))
    ff <- 1
    r[i+1,1] <- s*h
    for(k in 1:i){
      r_1 <- r[i+1,k]
      r_2 <- r[i,k]
      ff <- 4*ff
      rr <- (ff*r_1-r_2)/(ff-1)
      r[i+1,k+1] <- rr
    }
    if(abs(rr-ro)<acc) break
  }
  print(r)
  return(rr)
}

print(romberg(sin, 0, 1, 5, 10^-8), digits=8)
print(romberg(exp, -3, 3, 5, 10^-8), digits=10)
