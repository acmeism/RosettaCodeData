using Formatting

function width{T<:Integer}(n::T)
    w = ndigits(n)
    n < 0 || return w
    return w + 1
end

function pretty{T<:Integer}(a::Array{T,2}, indent::Int=4)
    lo, hi = extrema(a)
    w = max(width(lo), width(hi))
    id = " "^indent
    fe = FormatExpr(@sprintf(" {:%dd}", w))
    s = id
    nrow = size(a)[1]
    for i in 1:nrow
        for j in a[i,:]
            s *= format(fe, j)
        end
        i != nrow || continue
        s *= "\n"*id
    end
    return s
end
