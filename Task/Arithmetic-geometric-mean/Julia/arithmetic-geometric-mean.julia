function agm(x, y, e::Real = 5)
    (x ≤ 0 || y ≤ 0 || e ≤ 0) && throw(DomainError("x, y must be strictly positive"))
    g, a = minmax(x, y)
    while e * eps(x) < a - g
        a, g = (a + g) / 2, sqrt(a * g)
    end
    a
end

x, y = 1.0, 1 / √2
println("# Using literal-precision float numbers:")
@show agm(x, y)

println("# Using half-precision float numbers:")
x, y = Float32(x), Float32(y)
@show agm(x, y)

println("# Using ", precision(BigFloat), "-bit float numbers:")
x, y = big(1.0), 1 / √big(2.0)
@show agm(x, y)
