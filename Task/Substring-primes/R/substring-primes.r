library(gmp)

#Start with the one-digit primes and an empty vector of composites
primes <- c(2, 3, 5, 7)
comps <- c()

repeat {
  np <- length(primes)
  #Append 3 and 7 to existing primes to get new possible primes
  #(No digit except the first can be 2 or 5)
  poss_primes <- outer(primes, c(3, 7), paste0) |> `dim<-`(NULL) |> as.numeric()
  #Check no substrings of possible primes are composite
  for (n in comps) poss_primes <- setdiff(poss_primes, grepv(n, poss_primes))
  #Update lists of which numbers found are prime and which are not
  primes <- union(primes, Filter(isprime, poss_primes))
  comps <- union(comps, setdiff(poss_primes, primes))
  #If no new primes are added, we are done
  if (length(primes) == np) break
}

cat(
  "These are all substring primes:", sort(primes),
  "\nThese numbers were tested but found to be composite:", sort(comps)
)
