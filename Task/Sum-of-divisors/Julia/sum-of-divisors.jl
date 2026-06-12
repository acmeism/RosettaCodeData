using Primes

function sumdivisors(n)
    f = [one(n)]
    for (p, e) in factor(n)
        f = reduce(vcat, [f * p^j for j in 1:e], init = f)
    end
    return sum(f)
end

for i in 1:100
    print(rpad(sumdivisors(i), 5), i % 25 == 0 ? " \n" : "")
end
