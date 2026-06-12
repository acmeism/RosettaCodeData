using Primes

let

    ecount, p, n = 0, 0, 0

    while ecount < 50_000
        p = nextprime(p + 1)
        n += p
        if isprime(n)
            ecount += 1
            if ecount < 31
                println("Sum of prime series up to $p: prime $n")
            elseif ecount in [1000, 2000, 3000, 4000, 5000, 30_000, 40_000, 50_000]
                println("Sum of $ecount in prime series up to $p: prime $n")
            end
        end
    end

end
