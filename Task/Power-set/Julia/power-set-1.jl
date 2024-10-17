function powerset(x::Vector{T})::Vector{Vector{T}} where T
    result = Vector{T}[[]]
    for elem in x, j in eachindex(result)
        push!(result, [result[j] ; elem])
    end
    result
end
