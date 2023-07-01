function nthroot(n::Integer, r::Real)
    r < 0 || n == 0 && throw(DomainError())
    n < 0 && return 1 / nthroot(-n, r)
    r > 0 || return 0
    x = r / n
    prevdx = r
    while true
        y = x ^ (n - 1)
        dx = (r - y * x) / (n * y)
        abs(dx) ≥ abs(prevdx) && return x
        x += dx
        prevdx = dx
    end
end

@show nthroot.(-5:2:5, 5.0)
@show nthroot.(-5:2:5, 5.0) - 5.0 .^ (1 ./ (-5:2:5))
