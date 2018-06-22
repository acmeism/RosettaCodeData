function fractran(n::Integer, ratios::Vector{<:Rational}, steplim::Integer)
    rst = zeros(BigInt, steplim)
    for i in 1:steplim
        rst[i] = n
        if (pos = findfirst(x -> isinteger(n * x), ratios)) > 0
            n *= ratios[pos]
        else
            break
        end
    end
    return rst
end

using IterTools
macro ratio_str(s)
    a = split(s, r"[\s,/]+")
    return collect(parse(BigInt, n) // parse(BigInt, d) for (n, d) in partition(a, 2))
end

fracs = ratio"""17 / 91, 78 / 85, 19 / 51, 23 / 38, 29 / 33, 77 / 29, 95 / 23,
                77 / 19, 1 / 17, 11 / 13, 13 / 11, 15 / 14, 15 / 2, 55 / 1"""
println("The first 20 in the series are ", fractran(2, fracs, 20))

prmfound = 0
n = big(2)
while prmfound < 20
    if isinteger(log2(n))
        prmfound += 1
        println("Prime $prmfound found: $n is 2 ^ $(Int(log2(n)))")
    end
    n = fractran(n, fracs, 2)[2]
end
