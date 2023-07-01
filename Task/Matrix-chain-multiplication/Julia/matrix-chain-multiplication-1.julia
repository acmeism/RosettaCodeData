module MatrixChainMultiplications

using OffsetArrays

function optim(a)
    n = length(a) - 1
    u = fill!(OffsetArray{Int}(0:n, 0:n), 0)
    v = fill!(OffsetArray{Int}(0:n, 0:n), typemax(Int))
    u[:, 1] .= -1
    v[:, 1] .= 0
    for j in 2:n, i in 1:n-j+1, k in 1:j-1
        c = v[i, k] + v[i+k, j-k] + a[i] * a[i+k] * a[i+j]
        if c < v[i, j]
            u[i, j] = k
            v[i, j] = c
        end
    end
    return v[1, n], aux(u, 1, n)
end

function aux(u, i, j)
    k = u[i, j]
    if k < 0
        return sprint(print, i)
    else
        return sprint(print, '(', aux(u, i, k), '×', aux(u, i + k, j - k), ")")
    end
end

end  # module MatrixChainMultiplications
