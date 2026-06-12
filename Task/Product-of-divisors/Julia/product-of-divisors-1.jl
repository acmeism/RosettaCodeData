using Primes

function proddivisors(n)
    f = [one(n)]
    for (p, e) in factor(n)
        f = reduce(vcat, [f * p^j for j in 1:e], init = f)
    end
    return prod(f)
end

for i in 1:50
    print(lpad(proddivisors(i), 10), i % 10 == 0 ? " \n" : "")
end
