using Combinatorics

meandiff(a::Vector{T}, b::Vector{T}) where T <: Real = mean(a) - mean(b)

function bifurcate(a::AbstractVector, sel::Vector{T}) where T <: Integer
    x         = a[sel]
    asel      = trues(length(a))
    asel[sel] = false
    y         = a[asel]
    return x, y
end

function permutation_test(treated::Vector{T}, control::Vector{T}) where T <: Real
    effect0 = meandiff(treated, control)
    pool    = vcat(treated, control)
    tlen    = length(treated)
    plen    = length(pool)
    better = worse = 0
    for subset in combinations(1:plen, tlen)
        t, c = bifurcate(pool, subset)
        if effect0 < meandiff(t, c)
            better += 1
        else
            worse += 1
        end
    end
    return better, worse
end
