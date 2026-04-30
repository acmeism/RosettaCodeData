options(scipen=10)

is_gapful <- function(n){
  first_digit <- n%/%10^(floor(log10(n)))
  last_digit <- n%%10
  (n/(10*first_digit+last_digit))%%1==0
}

list_gapfuls <- function(start, limit){
  n <- start
  count <- 0
  cat("First", limit, "gapful numbers from", start, "\n")
  while(count<limit){
    if(is_gapful(n)){
      cat(n, "")
      count <- count+1
    }
    n <- n+1
  }
}

list_gapfuls(100, 30)
list_gapfuls(1000000, 15)
list_gapfuls(1000000000, 10)
