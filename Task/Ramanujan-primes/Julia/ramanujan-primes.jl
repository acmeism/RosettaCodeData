using Primes

@time let
        MASK = primesmask(625000)
        PIVEC = accumulate(+, MASK)
        PI(n) = n < 1 ? 0 : PIVEC[n]

    function Ramanujan_prime(n)
        maxposs = Int(ceil(4n * (log(4n) / log(2))))
        for i in maxposs:-1:1
            PI(i) - PI(i ÷ 2) < n && return i + 1
        end
        return 0
    end

    for i in 1:100
        print(lpad(Ramanujan_prime(i), 5), i % 20 == 0 ? "\n" :  "")
    end

    println("\nThe 1000th Ramanujan prime is ", Ramanujan_prime(1000))
    println("\nThe 10,000th Ramanujan prime is ", Ramanujan_prime(10000))
end
