library(primefactr)
n<-1000
odd_primes_n <- AllPrimesUpTo(n)
odd_primes_n <- odd_primes_n[2:length(odd_primes_n)]

Odd_squarefree_semiprimes <- c()
for (p in odd_primes_n){
 q <- odd_primes_n[(p<odd_primes_n)&(odd_primes_n<= (n%/%p))]
 q<- q[q!=p]
 Odd_squarefree_semiprimes <- c(Odd_squarefree_semiprimes,p*q)
}

cat(Odd_squarefree_semiprimes)
cat("\n")
cat(paste0("total number of Odd squarefree semirprimes below ", n," : ",length(Odd_squarefree_semiprimes)))

