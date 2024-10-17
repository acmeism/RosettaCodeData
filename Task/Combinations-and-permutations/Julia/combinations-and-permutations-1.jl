function Base.binomial{T<:FloatingPoint}(n::T, k::T)
    exp(lfact(n) - lfact(n - k) - lfact(k))
end

function Base.factorial{T<:FloatingPoint}(n::T, k::T)
    exp(lfact(n) - lfact(k))
end

⊞{T<:Real}(n::T, k::T) = binomial(n, k)
⊠{T<:Real}(n::T, k::T) = factorial(n, n-k)
