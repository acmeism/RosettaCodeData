using Primes

""" Return the factors of n, including 1, n """
function factors(n::T)::Vector{T} where T <: Integer
  sort(vec(map(prod, Iterators.product((p.^(0:m) for (p, m) in eachfactor(n))...))))
end

const examples = [28, 45, 53, 64, 6435789435768]

for n in examples
    @time println("The factors of $n are: $(factors(n))")
end
