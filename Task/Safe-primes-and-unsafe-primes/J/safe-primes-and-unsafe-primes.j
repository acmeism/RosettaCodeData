primeQ =: 1&p:
safeQ =: primeQ@:-:@:<:
Filter =: (#~`)(`:6)
K =: adverb def 'm * 1000'
PRIMES =: i.&.:(p:inv) 10 K K
SAFE =: safeQ Filter PRIMES
UNSAFE =: PRIMES -. SAFE
