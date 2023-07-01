function pancake(len)
    goalstack = collect(1:len)
    stacks, numstacks = Dict(goalstack => 0), 1
    newstacks = deepcopy(stacks)
    for i in 1:1000
        nextstacks = Dict()
        for (arr, steps) in newstacks, pos in 2:len
            newstack = vcat(reverse(arr[1:pos]), arr[pos+1:end])
            haskey(stacks, newstack) || (nextstacks[newstack] = i)
        end
        newstacks = nextstacks
        stacks = merge(stacks, newstacks)
        perms = length(stacks)
        perms == numstacks && return findmax(stacks)
        numstacks = perms
    end
end

for i in 1:10
    steps, example = pancake(i)
    println("pancake(", lpad(i, 2), ") = ", rpad(steps, 5), " example: ", example)
end
