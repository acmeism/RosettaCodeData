function makerunningstd(::Type{T} = Float64) where T
    ∑x = ∑x² = zero(T)
    n = 0
    function runningstd(x)
        ∑x  += x
        ∑x² += x ^ 2
        n   += 1
        s   = ∑x² / n - (∑x / n) ^ 2
        return s
    end
    return runningstd
end

test = Float64[2, 4, 4, 4, 5, 5, 7, 9]
rstd = makerunningstd()

println("Perform a running standard deviation of ", test)
for i in test
    println(" - add $i → ", rstd(i))
end
