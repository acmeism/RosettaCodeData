julia> using LinearAlgebra

julia> function testsvd()
           rows, cols = [parse(Int, s) for s in split(readline())]
           arr = zeros(rows, cols)
           for row in 1:rows
               arr[row, :] .= [tryparse(Float64, s) for s in split(readline())]
           end
           display(svd(arr))
       end
testsvd (generic function with 1 method)

julia> testsvd()
2 2
3 0
4 5
SVD{Float64, Float64, Matrix{Float64}, Vector{Float64}}
U factor:
2×2 Matrix{Float64}:
 -0.316228  -0.948683
 -0.948683   0.316228
singular values:
2-element Vector{Float64}:
 6.70820393249937
 2.2360679774997894
Vt factor:
2×2 Matrix{Float64}:
 -0.707107  -0.707107
 -0.707107   0.707107
