n <- 100000
u <- sqrt(-2*log(runif(n)))
v <- 2*pi*runif(n)
x <- u*cos(v)
y <- v*sin(v)
hist(x)
