#This is equivalent to n*(n^2+1)/2, but it's easier to see where this form comes from
magic <- function(n) sum(1:(n^2))/n

sapply(3:22, magic)
magic(1003)

inv_magic <- function(lower){
  n <- 3
  while(magic(n)<=lower) n <- n+1
  return(n)
}

sapply(cumprod(rep(10, 20)), inv_magic)
