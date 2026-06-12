julia> using LinearAlgebra

julia> twodiagonalsparse(n) = I(n) .| rotl90(I(n))
twodiagonalsparse (generic function with 1 method)

julia> twodiagonalsparse(7)
7×7 SparseArrays.SparseMatrixCSC{Bool, Int64} with 13 stored entries:
 1  ⋅  ⋅  ⋅  ⋅  ⋅  1
 ⋅  1  ⋅  ⋅  ⋅  1  ⋅
 ⋅  ⋅  1  ⋅  1  ⋅  ⋅
 ⋅  ⋅  ⋅  1  ⋅  ⋅  ⋅
 ⋅  ⋅  1  ⋅  1  ⋅  ⋅
 ⋅  1  ⋅  ⋅  ⋅  1  ⋅
 1  ⋅  ⋅  ⋅  ⋅  ⋅  1

julia> twodiagonalsparse(8)
8×8 SparseArrays.SparseMatrixCSC{Bool, Int64} with 16 stored entries:
 1  ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  1
 ⋅  1  ⋅  ⋅  ⋅  ⋅  1  ⋅
 ⋅  ⋅  1  ⋅  ⋅  1  ⋅  ⋅
 ⋅  ⋅  ⋅  1  1  ⋅  ⋅  ⋅
 ⋅  ⋅  ⋅  1  1  ⋅  ⋅  ⋅
 ⋅  ⋅  1  ⋅  ⋅  1  ⋅  ⋅
 ⋅  1  ⋅  ⋅  ⋅  ⋅  1  ⋅
 1  ⋅  ⋅  ⋅  ⋅  ⋅  ⋅  1
