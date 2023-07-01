using Primes
using Printf

ordi(n) = n == 1 ? "st" : n == 2 ? "nd" : "th"

function SmarandacheWellin()
    pri = primes(12500)
    sw = ""
    pcount = 0
    i = 1
    println("The known Smarandache-Wellin primes are:")
    while pcount < 8
        sw *= string(pri[i])
        if isprime(parse(BigInt, sw))
            pcount += 1
            le = length(sw)
            sws = le > 4 ? sw[1:20] * "..." * sw[le-19:le] : sw
            @printf("%d%s: index %4d  digits %4d  last prime %5d -> %s\n", pcount, ordi(pcount), i, le, pri[i], sws)
        end
        i += 1
    end
    println("\nThe first 20 Derived Smarandache-Wellin primes are:")
    freqs = zeros(Int, 10)
    pcount = 0
    i = 1
    while pcount < 20
        p = string(pri[i])
        for d in p
            n = parse(Int, string(d)) + 1
            freqs[n] += 1
        end
        dsw = string(parse(BigInt, prod(map(string, freqs))))
        if isprime(parse(BigInt, dsw))
            pcount += 1
            @printf("%4d: index %4d  prime %s\n", pcount, i, dsw)
        end
        i += 1
    end
end

SmarandacheWellin()
