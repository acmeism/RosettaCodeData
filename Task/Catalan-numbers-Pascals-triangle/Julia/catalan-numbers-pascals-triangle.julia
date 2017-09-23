# v0.6

function pascal(n::Int)
    r = ones(Int, n, n)
    for i in 2:n, j in 2:n
        r[i, j] = r[i-1, j] + r[i, j-1]
    end
    return r
end

function catalan_num(n::Int)
    p = pascal(n + 2)
    p[n+4:n+3:end-1] - diag(p, 2)
end

@show catalan_num(15)
