function gss(arr::Vector{<:Number})
    smax = hmax = tmax = 0
    for head in eachindex(arr), tail in head:length(arr)
        s = sum(arr[head:tail])
        if s > smax
            smax = s
            hmax, tmax = head, tail
        end
    end
    return arr[hmax:tmax]
end

arr = [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
subseq = gss(arr)
s = sum(subseq)

println("Greatest subsequential sum of $arr:\n → $subseq with sum $s")
