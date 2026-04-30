library(gmp) #for big number factorization
options(scipen=20)

arith_deriv <- function(x) {
  if(x %in% c(0, 1, -1)) return(0)
  n <- abs(x)
  facs <- as.numeric(factorize(n))
  nfacs <- length(facs)
  if(nfacs == 1) return(sign(x))
  d <- sum(facs[1:2])
  if(nfacs > 2) {
    c_prod <- cumprod(facs)
    for(i in 3:nfacs) d <- d*facs[i]+c_prod[i-1]
  }
  sign(x)*d
}

t(matrix(sapply(-99:100, arith_deriv), nrow=10))

pows <- 10^(1:20)
derivs <- sapply(pows, arith_deriv)
writeLines(paste0("D(", pows, ")/7 = ", derivs/7))
