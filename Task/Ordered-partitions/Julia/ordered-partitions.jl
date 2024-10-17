using Combinatorics

function masked(mask, lis)
    combos = []
    idx = 1
    for step in mask
        if(step < 1)
            push!(combos, Array{Int,1}[])
        else
            push!(combos, sort(lis[idx:idx+step-1]))
            idx += step
        end
    end
    Array{Array{Int, 1}, 1}(combos)
end

function orderedpartitions(mask)
    tostring(masklis) = replace("$masklis", r"Array{Int\d?\d?,1}|Int\d?\d?", "")
    join([tostring(lis) for lis in unique([masked(mask, p)
                        for p in permutations(1:sum(mask))])], "\n")
end

println(orderedpartitions([2, 0, 2]))
println(orderedpartitions([1, 1, 1]))
