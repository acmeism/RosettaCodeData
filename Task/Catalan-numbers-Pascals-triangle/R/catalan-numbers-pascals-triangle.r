pascal_row <- function(n) choose(n, 0:n)

catalan <- function(n){
  pr <- pascal_row(2*n)
  pr[n+1]-pr[n+2]
}

cat(sapply(1:15, catalan), "\n")
