using Primes

let
    p = primesmask(1000)
    println("Cousin prime pairs under 1,000:")
    pcount = 0
    for i in 2:996
        if p[i] && p[i + 4]
            pcount += 1
            print(lpad(i, 4), ":", rpad(i + 4, 4), pcount % 8 == 0 ? "\n" : "")
        end
    end
    println("\n\n$pcount pairs found.")
end
