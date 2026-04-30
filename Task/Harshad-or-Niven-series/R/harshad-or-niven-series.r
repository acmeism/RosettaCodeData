numdigits <- function(n) ifelse(log10(n)%%1==0,
                                1+log10(n),
                                ceiling(log10(n)))

digsum <- function(n){
  k <- numdigits(n)
  get_digit <- function(m) (n%/%10^m)%%10
  sum(sapply(0:(k-1), get_digit))
}

is_harshad <- function(n) (n/digsum(n))%%1==0

list_harshads <- function(start, limit){
  n <- start
  count <- 0
  while(count<limit){
    if(is_harshad(n)){
      print(n)
      count <- count+1
    }
    n <- n+1
  }
}

list_harshads(1, 20)
list_harshads(1001, 1)
