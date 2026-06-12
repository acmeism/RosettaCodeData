using Primes

let
    pmask, pcount = primesmask(1, 994), 0
    isreversibleprime(n) = pmask[n] && pmask[evalpoly(10, reverse(digits(n)))]

    println("Reversible primes between 0 and 500:")
    for n in 1:499
        if isreversibleprime(n)
            pcount += 1
            print(rpad(n, 4), pcount % 17 == 0 ? "\n" : "")
        end
    end
    println("Total found: $pcount")
end
