struct maybe x::Union{Real, Missing}; end

Base.show(io::IO, m::maybe) = print(io, m.x)

unit(x) = maybe(x)
bind(f, x) = unit(f(x.x))

f1(x) = 5x
f2(x) = x + 4

a = unit(3)
b = unit(missing)

println(a, " -> ", bind(f2, bind(f1, a)))

println(b, " -> ", bind(f2, bind(f1, b)))
