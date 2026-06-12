using Polynomials

function Lagrange(pts::Vector{Vector{Int}})
    xs = first.(pts)
    cs = last.(pts)
    n = length(xs)
    n == 1 && return Polynomial(cs[1])
    arr = ones(Int, n)
    for j in 2:n
        for k in 1:j
            arr[k] = (xs[k] - xs[j]) * arr[k]
        end
        arr[j] = prod(xs[j] - xs[i] for i in 1:(j - 1))
    end
    ws = 1 .// arr
    q = Polynomial(0 // 1)
    x = variable(q)
    for i in eachindex(ws)
        m = prod(x - xs[j] for j in eachindex(xs) if j != i)
        q += m * ws[i] * cs[i]
    end
    return q
end

const testpoints = [[1, 1], [2, 4], [3, 1], [4, 5]]
@show Lagrange(testpoints)
