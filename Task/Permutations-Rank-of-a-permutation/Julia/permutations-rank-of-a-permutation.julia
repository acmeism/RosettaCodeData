using Printf

nobjs = 4
a = collect(1:nobjs)
println("All permutations of ", nobjs, " objects:")
for i in 1:factorial(nobjs)
    p = nthperm(a, i)
    prank = nthperm(p)
    print(@sprintf("%5d => ", i))
    println(p, " (", prank, ")")
end

nobjs = 12
nsamp = 4
ptaken = Int[]
println()
println(nsamp, " random permutations of ", nobjs, " objects:")
for i in 1:nsamp
    p = randperm(nobjs)
    prank = nthperm(p)
    while prank in ptaken
        p = randperm(nobjs)
        prank = nthperm(p)
    end
    push!(ptaken, prank)
    println("         ", p, " (", prank, ")")
end
