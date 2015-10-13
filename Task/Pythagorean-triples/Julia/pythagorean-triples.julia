function primitiven{T<:Integer}(m::T)
    1 < m || return T[]
    m != 2 || return T[1]
    !isprime(m) || return T[2:2:m-1]
    rp = trues(m-1)
    if isodd(m)
        rp[1:2:m-1] = false
    end
    for p in keys(factor(m))
        rp[p:p:m-1] = false
    end
    T[1:m-1][rp]
end

function pythagoreantripcount{T<:Integer}(plim::T)
    primcnt = 0
    fullcnt = 0
    11 < plim || return (primcnt, fullcnt)
    for m in 2:plim
        p = 2m^2
        p+2m <= plim || break
        for n in primitiven(m)
            q = p + 2m*n
            q <= plim || break
            primcnt += 1
            fullcnt += div(plim, q)
        end
    end
    return (primcnt, fullcnt)
end

println("Counting Pythagorian Triplets within perimeter limits:")
println("    Limit          All   Primitive")
for om in 1:10
    (pcnt, fcnt) = pythagoreantripcount(10^om)
    println(@sprintf "    10^%02d  %11d   %9d" om fcnt pcnt)
end
