function postprecision(str::String)
    s = lowercase(str)
    if 'e' in s
        s, ex = split(s, "e")
        expdig = parse(Int, ex)
    else
        expdig = 0
    end
    dig = something(findfirst('.', reverse(s)), 1) - 1 - expdig
    return dig > 0 ? dig : 0
end

postprecision(x::Integer) = 0
postprecision(x::Real, max=22) = postprecision(string(round(Float64(x), digits=max)))

testnums = ["0.00100", 0.00100, 001.805, 1.0 / 3, 2//3, 12, 12.345, "12.3450",
    "12.34555555555555555555", 1.2345e+54, 1.2345e-08, "1.2345e-08", π]

for n in testnums
    println("$n has $(postprecision(n)) decimals.")
end
