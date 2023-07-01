using QuadGK
gammaquad(t::Float64) = first(quadgk(x -> x ^ (t - 1) * exp(-x), zero(t), Inf, reltol = 100eps(t)))
@show gammaquad(1.0)
