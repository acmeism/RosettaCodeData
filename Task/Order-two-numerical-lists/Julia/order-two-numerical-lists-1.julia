function isallreal{T<:AbstractArray}(a::T)
    all(map(x->isa(x, Real), a))
end

function islexfirst{T<:AbstractArray,U<:AbstractArray}(a::T, b::U)
    isallreal(a) && isallreal(b) || throw(DomainError())
    for i in 1:min(length(a), length(b))
        x = a[i]
        y = b[i]
        x != y || continue
        return x < y
    end
    return length(a) < length(b)
end
