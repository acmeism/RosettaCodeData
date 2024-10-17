const PFCUT = [6:5:101]//100
const PFVAL = [10:8:26, 32:6:50, 54:4:98, 100]//100

function pricefraction{T<:FloatingPoint}(a::T)
    zero(T) <= a || error("a = ", a, ", but it must be >= 0.")
    a <= one(T) || error("a = ", a, ", but it must be <= 1.")
    convert(T, PFVAL[findfirst(a .< PFCUT)])
end

test = [0.:0.05:1., 0.51, 0.56, 0.61, rand(), rand(), rand(), rand()]

println("Testing the price fraction function")
for t in test
    println(@sprintf "    %.4f -> %.4f" t pricefraction(t))
end
