using Primes

function numfactors(n)
    f = [one(n)]
    for (p, e) in factor(n)
        f = reduce(vcat, [f * p^j for j in 1:e], init = f)
    end
    length(f)
end

for i in 1:100
    print(rpad(numfactors(i), 3), i % 25 == 0 ? " \n" : " ")
end
