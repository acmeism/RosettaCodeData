function sleepsort(arr::Vector{<:Real})
    out = Vector{eltype(arr)}(0)
    sizehint!(out, length(arr))
    @sync for x in arr
        @async begin
            sleep(x)
            push!(out, x)
        end
    end
    return out
end

v = rand(-10:10, 10)
println("# unordered: $v\n -> ordered: ", sleepsort(v))
