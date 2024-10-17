using Formatting

function integer_sqrt(x)
    @assert(x >= 0)
    q = one(x)
    while q <= x
        q <<= 2
    end
    z, r = x, zero(x)
    while q > 1
        q >>= 2
        t = z - r - q
        r >>= 1
        if t >= 0
            z = t
            r += q
        end
    end
    return r
end

println("The integer square roots of integers from 0 to 65 are:")
println(integer_sqrt.(collect(0:65)))

println("\nThe integer square roots of odd powers of 7 from 7^1 up to 7^73 are:\n")
println("power", " "^36, "7 ^ power", " "^60, "integer square root")
println("----- ", "-"^80, " ------------------------------------------")
pow7 = big"7"
for i in 1:2:73
    println(lpad(i, 2), lpad(format(pow7^i, commas=true), 84),
        lpad(format(integer_sqrt(pow7^i), commas=true), 43))
end
