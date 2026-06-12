using Primes

const range = 2:999

for base in [2:10...;[16, 17, 27, 31, 62]]
    primes = filter(n -> isprime(n) && issorted(digits(n, base=base), rev=true), range)
    println("\nBase $base: ", length(primes), " non-descending primes between 1 and ",
        string(last(primes), base=base), ":")
    foreach(p -> print(lpad(string(p[2], base=base), 5), p[1] % 16 == 0 ? "\n" : ""), enumerate(primes))
end
