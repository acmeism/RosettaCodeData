function ludic_filter{T<:Integer}(n::T)
    0 < n || throw(DomainError())
    slud = trues(n)
    for i in 2:(n-1)
        slud[i] || continue
        x = 0
        for j in (i+1):n
            slud[j] || continue
            x += 1
            x %= i
            x == 0 || continue
            slud[j] = false
        end
    end
    return slud
end

ludlen = 10^5
slud = ludic_filter(ludlen)
ludics = collect(1:ludlen)[slud]

n = 25
println("Generate and show here the first ", n, " ludic numbers.")
print("    ")
crwid = 76
wid = 0
for i in 1:(n-1)
    s = @sprintf "%d, " ludics[i]
    wid += length(s)
    if crwid < wid
        print("\n    ")
        wid = 0
    end
    print(s)
end
println(ludics[n])

n = 10^3
println()
println("How many ludic numbers are there less than or equal to ", n, "?")
println("    ", sum(slud[1:n]))

lo = 2000
hi = lo+5
println()
println("Show the ", lo, "..", hi, "'th ludic numbers.")
for i in lo:hi
    println("    Ludic(", i, ") = ", ludics[i])
end

n = 250
println()
println("Show all triplets of ludic numbers < ", n)
for i = 1:n-7
    slud[i] || continue
    j = i+2
    slud[j] || continue
    k = i+6
    slud[k] || continue
    println("    ", i, ", ", j, ", ", k)
end
