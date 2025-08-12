library(gmp)

nth_repunit <- function(n, base) (as.bigz(base)^n-1)/(base-1)
repunit_primes <- function(base) which(isprime(nth_repunit(1:1000, base))!=0)
primes_list <- lapply(2:16, repunit_primes)
names(primes_list) <- sapply(2:16, function(k) paste("Base", k))
for(i in 1:15) if(length(primes_list[[i]])==0) primes_list[[i]] <- "None"
print(primes_list, quote=FALSE)
