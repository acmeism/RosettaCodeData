function rankstandard{T<:Real}(a::Array{T,1})
    r = collect(1:length(a))
    1 < r[end] || return r
    for i in ties(a)
        r[a.==i] = r[a.==i][1]
    end
    return r
end
