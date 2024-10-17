function ties{T<:Real}(a::Array{T,1})
    unique(a[2:end][a[2:end] .== a[1:end-1]])
end
