function twoidenticalstringsinbase(base, maxnum, verbose=true)
    found = Int[]
    for i in 1:maxnum
        dig = digits(i; base)
        k = length(dig)
        iseven(k) && dig[begin:begin+k÷2-1] == dig[begin+k÷2:end] && push!(found, i)
    end
    if verbose
        println("\nDecimal  Base $base")
        for n in found
            println(rpad(n, 9), string(n, base=base))
        end
    end
    return found
end

twoidenticalstringsinbase(2, 999)
twoidenticalstringsinbase(16, 999)
