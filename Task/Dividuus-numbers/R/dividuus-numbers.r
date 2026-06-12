numdigits <- function(n) ifelse(log10(n)%%1==0,
                                1+log10(n),
                                ceiling(log10(n)))

dspread <- function(f, n){
  k <- numdigits(n)
  get_digit <- function(m) (n%/%10^m)%%10
  f(sapply(0:(k-1), get_digit))
}

digsum <- function(n) dspread(sum, n)
digmul <- function(n) dspread(prod, n)

diterate <- function(f, n){
  while(n > 9) n <- f(n)
  return(n)
}

digroot <- function(n) diterate(digsum, n)
mdigroot <- function(n) diterate(digmul, n)

is_dividuus <- function(n){
  divisors <- c(digsum(n), digmul(n), digroot(n), mdigroot(n))
  if(0 %in% divisors) return(FALSE)
  all(n%%divisors==0)
}

n <- 1
nums <- numeric(0)
while(length(nums) < 50){
  if(is_dividuus(n)) nums <- c(nums, n)
  n <- n+1
}
print(nums)
