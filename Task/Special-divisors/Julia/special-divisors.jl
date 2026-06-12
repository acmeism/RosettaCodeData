using Primes

function divisors(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    return f[1:end-1]
end

function isspecialdivisor(n)::Bool
    isprime(n) && return true
    nreverse = evalpoly(10, reverse(digits(n)))
    for d in divisors(n)
        dreverse = evalpoly(10, reverse(digits(d)))
        !(nreverse ÷ dreverse ≈ nreverse / dreverse) && return false
    end
    return true
end

const specials = filter(isspecialdivisor, 1:200)
foreach(p -> print(rpad(p[2], 4), p[1] % 18 == 0 ? "\n" : ""), enumerate(specials))
