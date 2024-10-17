leftfactorial(n::Integer) = n ≤ 0 ? zero(n) : sum(factorial, 0:n-1)

@show leftfactorial.(0:10)
@show ndigits.(leftfactorial.(big.(1000:1000:10_000)))
