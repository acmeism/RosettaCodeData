using Primes

# modified from reinermartin's PR at https://github.com/JuliaMath/Primes.jl/pull/70/files
function moebius(n::Integer)
    @assert n > 0
    m(p, e) = p == 0 ? 0 : e == 1 ? -1 : 0
    reduce(*, m(p, e) for (p, e) in factor(n) if p ≥ 0; init=1)
end
μ(n) = moebius(n)

print("First 199 terms of the Möbius sequence:\n   ")
for n in 1:199
    print(lpad(μ(n), 3), n % 20 == 19 ? "\n" : "")
end
