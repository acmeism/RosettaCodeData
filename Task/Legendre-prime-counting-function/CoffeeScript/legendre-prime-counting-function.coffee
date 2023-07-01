sorenson = require('sieve').primes  # Sorenson's extensible sieve from task: Extensible Prime Generator

# put in outer scope to avoid recomputing the cache
memoPhi = {}
primes = []

isqrt = (x) -> Math.floor Math.sqrt x

pi = (n) ->
    phi = (x, a) ->
        y = memoPhi[[x,a]]
        return y unless y is undefined

        memoPhi[[x,a]] =
            if a is 0 then x
            else
                p = primes[a - 1]
                throw "You need to generate at least #{a} primes." if p is undefined
                phi(x, a - 1) - phi(x // p, a - 1)

    if n < 2
        0
    else
        a = pi isqrt n
        phi(n, a) + a - 1

maxPi = 1e9
gen = sorenson()
primes = while (p = gen.next().value) < isqrt maxPi then p

n = 1
for i in [0..9]
    console.log "10^#{i}\t#{pi(n)}"
    n *= 10
