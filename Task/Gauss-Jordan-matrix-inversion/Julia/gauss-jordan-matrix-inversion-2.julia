function gaussjordan(A::Matrix)
    size(A, 1) == size(A, 2) || throw(ArgumentError("A must be squared"))
    n = size(A, 1)
    M = [convert(Matrix{float(eltype(A))}, A) I]
    i = 1
    local tmp = Vector{eltype(M)}(2n)
    # forward
    while i ≤ n
        if M[i, i] ≈ 0.0
            local j = i + 1
            while j ≤ n && M[j, i] ≈ 0.0
                j += 1
            end
            if j ≤ n
                tmp     .= M[i, :]
                M[i, :] .= M[j, :]
                M[j, :] .= tmp
            else
                throw(ArgumentError("matrix is singular, cannot compute the inverse"))
            end
        end
        for j in (i + 1):n
            M[j, :] .-= M[j, i] / M[i, i] .* M[i, :]
        end
        i += 1
    end
    i = n
    # backward
    while i ≥ 1
        if M[i, i] ≈ 0.0
            local j = i - 1
            while j ≥ 1 && M[j, i] ≈ 0.0
                j -= 1
            end
            if j ≥ 1
                tmp     .= M[i, :]
                M[i, :] .= M[j, :]
                M[j, :] .= tmp
            else
                throw(ArgumentError("matrix is singular, cannot compute the inverse"))
            end
        end
        for j in (i - 1):-1:1
            M[j, :] .-= M[j, i] / M[i, i] .* M[i, :]
        end
        i -= 1
    end
    M ./= diag(M) # normalize
    return M[:, n+1:2n]
end

@show gaussjordan(A)
@assert gaussjordan(A) ≈ inv(A)

A = rand(10, 10)
@assert gaussjordan(A) ≈ inv(A)
