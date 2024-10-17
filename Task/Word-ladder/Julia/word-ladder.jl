const dict = Set(split(read("unixdict.txt", String), r"\s+"))

function targeted_mutations(str::AbstractString, target::AbstractString)
    working, tried = [[str]], Set{String}()
    while all(a -> a[end] != target, working)
        newworking = Vector{Vector{String}}()
        for arr in working
            s = arr[end]
            push!(tried, s)
            for j in 1:length(s), c in 'a':'z'
                w = s[1:j-1] * c * s[j+1:end]
                if w in dict && !(w in tried)
                    push!(newworking, [arr; w])
                end
            end
        end
        isempty(newworking) && return [["This cannot be done."]]
        working = newworking
    end
    return filter(a -> a[end] == target, working)
end

println("boy to man: ", targeted_mutations("boy", "man"))
println("girl to lady: ", targeted_mutations("girl", "lady"))
println("john to jane: ", targeted_mutations("john", "jane"))
println("child to adult: ", targeted_mutations("child", "adult"))
