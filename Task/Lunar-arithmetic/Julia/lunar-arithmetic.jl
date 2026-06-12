""" https://rosettacode.org/wiki/Lunar_arithmetic """

""" lunar addition """
function ⊕(a, b, base = 10)
    pad = max(ndigits(a), ndigits(b))
    da, db = digits(a; base, pad), digits(b; base, pad)
    return evalpoly(base, [max(da[i], db[i]) for i in 1:pad])
end

""" lunar multiplication helper function """
function lunar_digit_mul(a, d, base = 10)
    da = digits(a; base)
    return evalpoly(base, [min(da[i], d) for i in eachindex(da)])
end

""" lunar multiplication """
function ⊗(a, b, base = 10)
    db = digits(b; base)
    return reduce(⊕, [base^(i - 1) * lunar_digit_mul(a, db[i], base) for i in eachindex(db)])
end

""" test lunar operators """
function testlunar()
    for test in [(976, 348), (23, 321), (232, 35), (123, 32192, 415, 8)]
        addval = 0
        mulval = 9
        addtext = "     Lunar add: "
        multext = "Lunar multiply: "
        for (i, val) in enumerate(test)
            if i > 1
                addtext *= " ⊕ "
                multext *= " ⊠ "
            end
            addtext *= string(val)
            multext *= string(val)

            addval = addval ⊕ val
            mulval = mulval ⊗ val
        end
        println("$addtext = $addval")
        println("$multext = $mulval")
        println()
    end
    println("First 20 distinct lunar even numbers:\n", unique([a ⊗ 2 for a in 0:201]))
    println("\nFirst 20 lunar square numbers:\n", [a ⊗ a for a in 0:19])
    println("\nFirst 20 lunar factorial numbers:\n", [reduce(⊗, collect(1:a), init = 1) for a in 1:20])
    println("\nFirst number whose lunar square is smaller than the previous: ",
        findfirst(x -> x ⊗ x < (x - 1) ⊗ (x - 1), 1:2000))
end

testlunar()
