using Primes

let
    pmask, pcount = primesmask(1, 5000), 0
    issum25prime(n) = pmask[n] && sum(digits(n)) == 25

    println("Primes with digits summing to 25 between 0 and 5000:")
    for n in 1:4999
        if issum25prime(n)
            pcount += 1
            print(rpad(n, 5))
        end
    end
    println("\nTotal found: $pcount")
end
