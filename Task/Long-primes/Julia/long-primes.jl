using Primes

function divisors(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    return length(f) == 1 ? [one(n), n] : sort!(f)
end

function islongprime(p)
    for i in divisors(p-1)
        if powermod(10, i, p) == 1
            return i + 1 == p
        end
    end
    false
end

println("Long primes ≤ 500: ")
for i in 2:500
    if islongprime(i)
        i == 229 ? println(i) : print(i, "  ")
    end
end
print("\n\n")

for i in [500, 1000, 2000, 4000, 8000, 16000, 32000, 64000]
    println("Number of long primes ≤ $i: $(sum(map(x->islongprime(x), 1:i)))")
end
