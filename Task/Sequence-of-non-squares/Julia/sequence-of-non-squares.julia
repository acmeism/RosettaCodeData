nonsquare(n::Real) = n + floor(typeof(n), 0.5 + sqrt(n))
@show nonsquare.(1:1_000_000) ∩ collect(1:1000) .^ 2
