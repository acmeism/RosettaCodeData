function rankdense{T<:Real}(a::Array{T,1})
    indexin(a, unique(a))
end
