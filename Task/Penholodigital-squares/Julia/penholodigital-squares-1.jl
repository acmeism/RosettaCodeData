""" rosettacode.org task Penholodigital_squares """


function penholodigital(base)
    penholodigitals = Int[]
    hi, lo = isqrt(evalpoly(base, 1:base-1)), isqrt(evalpoly(base, base-1:-1:1))
    for n in lo:hi
        dig = digits(n * n; base)
        0 in dig && continue
        if all(i -> count(==(i), dig) == 1, 1:base-1)
            push!(penholodigitals, n * n)
        end
    end
    return penholodigitals
end

for j in 9:16
    allpen = penholodigital(j)
    println("\n\nThere is a total of $(length(allpen)) penholodigital squares in base $j:")
    for (i, n) in (j < 14 ? enumerate(allpen) : enumerate([allpen[begin], allpen[end]]))
        print(string(isqrt(n), base=j), "² = ", string(n, base=j), i %3 == 0 ? "\n" :  "  ")
    end
end
