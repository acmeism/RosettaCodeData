library(gmp)
library(stringr)

fractran <- function(s, n, lim){
  P <- str_split_1(s, " ") |> str_split("/")
  read_frac <- function(index) as.bigq(n=P[[index]][1], d=P[[index]][2])
  fracs <- sapply(seq_along(P), read_frac)
  first_integer <- function(bigv, n){
    for(q in bigv){
      if(denominator(n*q)==1) return(q)
    }
    return(NA)
  }
  iters <- 0
  while(!is.na(first_integer(fracs, n))){
    n <- n*first_integer(fracs, n)
    print(n, initLine=FALSE)
    iters <- iters+1
    if(iters>=lim) break
  }
}

#Test input
fractran_primes <- "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"
fractran(fractran_primes, 2, 15)
