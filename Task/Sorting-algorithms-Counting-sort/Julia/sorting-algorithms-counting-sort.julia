function countsort(a::Vector{<:Integer})
    lo, hi = extrema(a)
    b   = zeros(a)
    cnt = zeros(eltype(a), hi - lo + 1)
    for i in a cnt[i-lo+1] += 1 end
    z = 1
    for i in lo:hi
        while cnt[i-lo+1] > 0
            b[z] = i
            z += 1
            cnt[i-lo+1] -= 1
        end
    end
    return b
end

v = rand(UInt8, 20)
println("# unsorted bytes: $v\n -> sorted bytes: $(countsort(v))")
v = rand(1:2 ^ 10, 20)
println("# unsorted integers: $v\n -> sorted integers: $(countsort(v))")
