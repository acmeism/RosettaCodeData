primes=: p: i. _1 p: 1000   NB. all prime numbers below 1000
sums=: +/\ primes           NB. running sum of those primes
mask=: 1 p: sums            NB. array of 0s, 1s where sums are primes

NB. indices of prime sums (incremented for 1-based indexing)
NB. "copy" only the final primes in the prime sums
NB. "copy" only the sums which are prime
results=: (>: I. mask) ,. (mask # primes) ,. (mask # sums)

NB. pretty-printed "boxed" output
output=: 2 1 $ ' n prime sum ' ; < results
