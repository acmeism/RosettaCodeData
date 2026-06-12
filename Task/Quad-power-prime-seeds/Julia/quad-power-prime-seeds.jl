using Primes, Formatting

isquadpowerprime(x) = all(isprime, [2x + 1, x^2 + x + 1, x^3 + x + 1, x^4 + x + 1])

const qpprimes = filter(isquadpowerprime, Int128(1):10_100_000)

foreach(n -> print(lpad(qpprimes[n], 9), n % 10 == 0 ? "\n" : ""), 1:50)

for j in 1_000_000:1_000_000:10_000_000
    for p in qpprimes
        if p > j
            println("The first quad-power prime seed over ", format(j, commas = true),
               " is ", format(p, commas = true))
            break
        end
    end
end

