list = [6, 81, 243, 14, 25, 49, 123, 69, 11]

function addleastreduce!(lis)
    while length(lis) > 1
         push!(lis, popat!(lis, last(findmin(lis))) + popat!(lis, last(findmin(lis))))
         println("Interim list: $lis")
    end
    return lis
end

@show list, addleastreduce!(copy(list))
