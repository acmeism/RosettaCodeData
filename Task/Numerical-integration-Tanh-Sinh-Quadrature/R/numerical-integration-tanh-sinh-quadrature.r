tanhsinh <- function(f, lower, upper, steps, acc) {
  h <- 0.1
  h0 <- (upper-lower)/2
  h1 <- (upper+lower)/2
  rr <- 0
  for (k in 1:steps) {
    ro <- rr
    n <- 2^k-1
    ss <- 0
    for (i in -n:n) {
      t <- i*h
      sh <- sinh(t)
      ch <- cosh(t)
      th <- tanh(sh*pi/2)
      dx <- (ch*pi/2)/(cosh(sh*pi/2)^2)
      xi <- h1+h0*th
      wt <- h*dx
      ss <- ss+f(xi)*wt
    }
    rr <- h0*ss
    if(abs(rr-ro) < acc) break
  }
  return(rr)
}

print(tanhsinh(sin, 0, 1, 5, 10^-8), digits=8)
print(tanhsinh(exp, -3, 3, 5, 10^-8), digits=10)
