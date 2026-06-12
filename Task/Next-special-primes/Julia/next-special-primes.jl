using Primes

let
    println("Special primes under 1050:\nPrime1 Prime2 Gap")
    println("     2     3   1")
    pmask = primesmask(1, 1050)
    n, gap = 3, 2
    while n + gap < 1050
        if pmask[n + gap]
            println(lpad(n, 6), lpad(n + gap, 6), lpad(gap, 4))
            n += gap
        end
        gap += 2
    end
end
