function hofstQseq(n, typerst::Type=Int)
    nmax = maximum(n)
    r = Vector{typerst}(nmax)
    r[1] = 1
    if nmax ≥ 2 r[2] = 1 end
    for i in 3:nmax
        r[i] = r[i - r[i - 1]] + r[i - r[i - 2]]
    end
    return r[n]
end

println("First ten elements of sequence: ", join(hofstQseq(1:10), ", "))
println("1000-th element: ", hofstQseq(1000))
