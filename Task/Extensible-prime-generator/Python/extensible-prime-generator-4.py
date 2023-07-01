from itertools import count, takewhile, islice

def prime_sieve():
    sieved = count(2)
    prime = next(sieved)
    yield prime
    primes = [prime]
    for x in sieved:
        possible_prime_divs = takewhile(lambda p: p <= x**0.5, primes)
        if any(x % prime == 0 for prime in possible_prime_divs):
            continue
        yield x
        primes.append(x)

if __name__ == '__main__':
    def leq_150(x): return x <= 150
    def leq_8000(x): return x <= 8000

    print("Show the first twenty primes.\n   =",
        list(islice(prime_sieve(), 20)))
    print("Show the primes between 100 and 150\n   =",
        [x for x in takewhile(leq_150, prime_sieve()) if x >= 100])
    print("Show the number of primes between 7,700 and 8,000.\n   =",
        sum(1 for x in takewhile(leq_8000, prime_sieve()) if x >= 7700))
    print("Show the 10,000th prime.\n   =",
        next(islice(prime_sieve(), 10000-1, 10000)))
