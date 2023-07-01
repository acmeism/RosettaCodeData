using Primes

function wilsonprimes(limit = 11000)
    sgn, facts = 1, accumulate(*, 1:limit, init = big"1")
    println(" n:  Wilson primes\n--------------------")
    for n in 1:11
        print(lpad(n, 2), ":  ")
        sgn = -sgn
        for p in primes(limit)
            if p > n && (facts[n < 2 ? 1 : n - 1] * facts[p - n] - sgn) % p^2 == 0
                print("$p ")
            end
        end
        println()
    end
end

wilsonprimes()
