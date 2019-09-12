using Primes

function factors(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    return length(f) == 1 ? [one(n), n] : sort!(f)
end

const examples = [28, 45, 53, 64, 6435789435768]

for n in examples
    @time println("The factors of $n are: $(factors(n))")
end
