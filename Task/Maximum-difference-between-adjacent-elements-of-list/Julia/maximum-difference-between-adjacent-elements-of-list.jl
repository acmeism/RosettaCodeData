function maxadjacentdiffs(list)
    pairs, maxδ = Pair{eltype(list)}[], abs(zero(eltype(list)))
    for i in eachindex(list[begin:end-1])
        x, y = list[i], list[i + 1]
        if (δ = abs(x - y)) == maxδ
            push!(pairs, x => y)
        elseif δ > maxδ
            maxδ, pairs = δ, [x => y]
        end
    end
    return maxδ, pairs
end

diff, pairs = maxadjacentdiffs(Real[1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3])

foreach(p -> println(p[1], ", ", p[2], " ==> ", diff), pairs)
