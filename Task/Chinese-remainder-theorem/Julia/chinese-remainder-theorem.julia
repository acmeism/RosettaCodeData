function chineseremainder(n::Array, a::Array)
    Π = prod(n)
    mod(sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a)), Π)
end

@show chineseremainder([3, 5, 7], [2, 3, 2])
