library(pracma)

for (idx in c(1,2*0:30)) {
  b <- bernoulli(idx)
  d <- as.character(denominator(b))
  n <- as.character(numerator(b))
  cat("B(",idx,") = ",n,"/",d,"\n", sep = "")
}
