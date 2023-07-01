using .Iterators: countfrom, flatten, repeated, zip
using .MathConstants: ℯ
using Printf

function cf(a₀, a, b = repeated(1))
	m = BigInt[a₀ 1; 1 0]
    for (aᵢ, bᵢ) ∈ zip(a, b)
        m *= [aᵢ 1; bᵢ 0]
        isapprox(m[1]/m[2], m[3]/m[4]; atol = 1e-12) && break
    end
	m[1]/m[2]
end

out((k, v)) = @printf "%2s: %.12f ≈ %.12f\n" k v eval(k)

foreach(out, (
    :(√2) => cf(1, repeated(2)),
    :ℯ    => cf(2, countfrom(), flatten((1, countfrom()))),
    :π    => cf(3, repeated(6), (k^2 for k ∈ countfrom(1, 2)))))
