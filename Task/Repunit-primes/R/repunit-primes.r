library(gmp)

repunit <- function(n, base) (as.bigz(base)^n - 1)/(base-1)
for (i in 2:16) {
  p <- which(isprime(repunit(1:1000, i)) != 0)
  cat("Base ", i, ":\n", sep = "")
  cat(if (length(p) > 0) p else "None", "\n")
}
