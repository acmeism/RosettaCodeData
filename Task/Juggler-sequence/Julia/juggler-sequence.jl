using Formatting

function juggler(k, countdig=true, maxiters=20000)
    m, maxj, maxjpos = BigInt(k), BigInt(k), BigInt(0)
    for i in 1:maxiters
        m = iseven(m) ? isqrt(m) : isqrt(m*m*m)
        if m >= maxj
            maxj, maxjpos  = m, i
        end
        if m == 1
            println(lpad(k, 9), lpad(i, 6), lpad(maxjpos, 6), lpad(format(countdig ?
                ndigits(maxj) : Int(maxj), commas=true), 20), countdig ? " digits" : "")
            return i
        end
    end
    error("Juggler series starting with $k did not converge in $maxiters iterations")
end

println("       n    l(n)  i(n)       h(n) or d(n)\n------------------------------------------")
foreach(k -> juggler(k, false), 20:39)
@time foreach(juggler,
    [113, 173, 193, 2183, 11229, 15065, 15845, 30817, 48443, 275485, 1267909,
     2264915, 5812827])
@time juggler(7110201)
