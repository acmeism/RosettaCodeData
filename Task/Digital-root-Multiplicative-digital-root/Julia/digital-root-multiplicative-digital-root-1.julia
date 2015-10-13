function digitalmultroot{S<:Integer,T<:Integer}(n::S, bs::T=10)
    -1 < n && 1 < bs || throw(DomainError())
    ds = n
    pers = 0
    while bs <= ds
        ds = prod(digits(ds, bs))
        pers += 1
    end
    return (pers, ds)
end
