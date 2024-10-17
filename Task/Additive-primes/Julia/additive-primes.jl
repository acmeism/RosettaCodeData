using Primes

let
    p = primesmask(500)
    println("Additive primes under 500:")
    pcount = 0
    for i in 2:499
        if p[i] && p[sum(digits(i))]
            pcount += 1
            print(lpad(i, 4), pcount % 20 == 0 ? "\n" : "")
        end
    end
    println("\n\n$pcount additive primes found.")
end
