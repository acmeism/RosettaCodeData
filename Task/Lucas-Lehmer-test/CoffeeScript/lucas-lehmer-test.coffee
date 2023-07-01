sorenson = require('sieve').primes  # Sorenson's extensible sieve from task: Extensible Prime Number Generator

# Test if 2^n-1 is a Mersenne prime.
# assumes that the argument p is prime.
#
isMersennePrime = (p) ->
    if p is 2 then yes
    else
        n = (1n << BigInt p) - 1n
        s = 4n
        s = (s*s - 2n) % n for _ in [1..p-2]
        s is 0n

primes = sorenson()
mersennes = []
while (p = primes.next().value) < 3000
    if isMersennePrime(p)
        mersennes.push p

console.log "Some Mersenne primes: #{"M" + String p for p in mersennes}"
