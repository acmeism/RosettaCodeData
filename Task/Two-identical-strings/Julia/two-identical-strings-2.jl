function twoidenticalstringsinbase(base, mx, verbose = true)
    gen = filter(x -> x < mx,
        reduce(vcat, [[i * (base^d + 1) for i in base^(d-1):base^d-1] for d in 1:ndigits(mx; base) ÷ 2]))
    if verbose
        println("\nDecimal  Base $base")
        foreach(n-> println(rpad(n, 9), string(n, base = base)), gen)
    end
    return gen
end

twoidenticalstringsinbase(2, 999)
twoidenticalstringsinbase(16, 999)
