function simpson(f::Function, a::Number, b::Number, n::Integer)
    h = (b - a) / n
    s = f(a + h / 2)
    for i in 1:(n-1)
        s += f(a + h * i + h / 2) + f(a + h * i) / 2
    end
    return h/6 * (f(a) + f(b) + 4*s)
end

rst =
    simpson(x -> x ^ 3, 0, 1, 100),
    simpson(x -> 1 / x, 1, 100, 1000),
    simpson(x -> x, 0, 5000, 5_000_000),
    simpson(x -> x, 0, 6000, 6_000_000)

@show rst
