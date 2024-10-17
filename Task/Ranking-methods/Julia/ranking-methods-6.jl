function rankfractional{T<:Real}(a::Array{T,1})
    r = float64(collect(1:length(a)))
    1.0 < r[end] || return r
    for i in ties(a)
        r[a.==i] = mean(r[a.==i])
    end
    return r
end
