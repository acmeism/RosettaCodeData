library(schoolmath) #to get prime numbers and to know if number is prime or not
n<- 500
all_primes_n <- primes(end=n)
reversed_primes_n = as.numeric(sapply(strsplit(as.character(all_primes_n),""),\(x){paste(rev(x),collapse="")}))
cat(all_primes_n[is.prim(reversed_primes_n)])
