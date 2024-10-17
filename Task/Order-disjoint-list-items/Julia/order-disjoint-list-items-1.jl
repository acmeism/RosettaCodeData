function order_disjoint(m::T, n::T) where T <: AbstractArray
    rlen = length(n)
    rdis = zeros(Int, rlen)
    for (i, e) in enumerate(n)
        j = something(findfirst(==(e), m), 0)
        while j in rdis && j != 0
            j = something(findnext(==(e), m, j+1), 0)
        end
        rdis[i] = j
    end
    if 0 in rdis
        throw(DomainError())
    end
    sort!(rdis)
    p = copy(m)
    p[rdis] .= n
    return p
end
