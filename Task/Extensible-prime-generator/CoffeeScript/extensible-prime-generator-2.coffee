primes = require('sieve').primes

gen = primes()
console.log "The first 20 primes: #{gen.next().value for _ in [1..20]}"

p100_150 = (while (p = gen.next().value) < 150 then p).filter (n) -> n > 100
console.log "The primes between 100 and 150: #{p100_150}"

while gen.next().value < 7700
    undefined
count = 1
while gen.next().value < 8000
    ++count

console.log "There are #{count} primes between 7,700 and 8,000."

n = 10
c = 0
gen = primes()
loop
    p = gen.next().value
    c += 1
    if c is n
        console.log "The #{n}th prime is #{p}"
        break if n is 10_000_000
        n *= 10
