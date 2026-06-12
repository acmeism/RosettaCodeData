function f2d(numr, denr)
    dpart, remainders, r = "", Dict{BigInt, Int}(), BigInt(numr) % denr
    while (r != 0) && !haskey(remainders, r)
        remainders[r] = length(dpart)
        r *= 10
        partrem, r = divrem(r, denr)
        dpart *= string(partrem)
    end
    return r == 0 ? (0, 0) : (dpart[remainders[r]+1:end], remainders[r])
end

overline(s) = mapreduce(c -> "\u0305" * c, *, s)

testpairs =  [(0, 1), (1, 1), (1, 3), (1, 7), (-83, 60), (1, 17), (10, 13), (3227, 555),
              (5^21, Int128(2)^63), (1, 149), (1, 5261)]

function testrepeatingdecimals()
    for (numr, denr) in testpairs
        n = numr < 0 ? -numr : numr
        repeated, extra = f2d(n, denr)
        if repeated == 0
            println(lpad("$numr/$denr", 36), "  (Period 0)     = ", BigFloat(numr)/denr)
        else
            prefix, suffix = split(string(BigFloat(numr) / denr)[begin:end-2], ".")
            println(lpad("$numr/$denr", 36), "  (Period ", rpad("$(length(repeated)))", 6),
                " = $prefix.$(suffix[begin:extra])$(overline(repeated))")
        end
    end
end

testrepeatingdecimals()
