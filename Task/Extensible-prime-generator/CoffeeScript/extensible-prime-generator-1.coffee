primes = () ->
    yield 2
    yield 3

    sieve = ([] for i in [1..3])
    sieve[0].push 3
    [r, s] = [3, 9]
    pos = 1
    n = 5
    loop
        isPrime = true
        if sieve[pos].length > 0  # this entry has a list of factors
            isPrime = false
            sieve[(pos + m) % sieve.length].push m for m in sieve[pos]
            sieve[pos] = []

        if n is s  # n is the next square
            if isPrime
                isPrime = false  # r divides n, so not actually prime
                sieve[(pos + r) % sieve.length].push r  # however, r is prime
            r += 2
            s = r*r

        yield n if isPrime
        n += 2
        pos += 1
        if pos is sieve.length
            sieve.push []  # array size must exceed largest prime found
            sieve.push []  # adding two entries keeps size = O(sqrt n)
            pos = 0

    undefined  # prevent CoffeeScript from aggregating values

module.exports = {
    primes
}
