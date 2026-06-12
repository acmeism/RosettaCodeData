function simps(f::Function, a::Number, b::Number, n::Number)
    iseven(n) || throw("n must be even, and $n was given")
    h = (b-a)/n
    s = f(a) + f(b)
    s += 4 * sum(f.(a .+ collect(1:2:n) .* h))
    s += 2 * sum(f.(a .+ collect(2:2:n-1) .* h))
    h/3 * s
end

println("Simpson's rule integration of sin from 0 to 1 is: ",  simps(sin, 0.0, 1.0, 100))
