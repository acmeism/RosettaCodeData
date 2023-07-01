using Primes

function isarithmetic(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    return rem(sum(f), length(f)) == 0
end

function arithmetic(n)
    i, arr = 1, Int[]
    while length(arr) < n
        isarithmetic(i) && push!(arr, i)
        i += 1
    end
    return arr
end

a1M = arithmetic(1_000_000)
composites = [!isprime(i) for i in a1M]

println("The first 100 arithmetic numbers are:")
foreach(p -> print(lpad(p[2], 5), p[1] % 20 == 0 ? "\n" : ""), enumerate(a1M[1:100]))

println("\n        X    Xth in Series  Composite")
for n in [1000, 10_000, 100_000, 1_000_000]
    println(lpad(n, 9), lpad(a1M[n], 12), lpad(sum(composites[2:n]), 14))
end
