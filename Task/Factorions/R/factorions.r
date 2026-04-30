fact_digsum <- function(n, b) {
  if(n > b-1) {
    factorial(n%%b)+fact_digsum(n%/%b, b)
  } else factorial(n)
}

for(i in 9:12) {
  cat("\nFactorions in base ", i, ":\n", sep="")
  for(j in 1:1499999) {
    if(j == fact_digsum(j, i)) cat(j, "")
  }
}
