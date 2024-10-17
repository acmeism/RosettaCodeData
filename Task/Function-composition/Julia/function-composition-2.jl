compose(f::Function, g::Function) = (x) -> g(f(x))
@show compose(sin, asin)(0.5)
