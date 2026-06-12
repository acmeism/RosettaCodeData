julia> twodiagonalmat(n) = [Int(i == j || i == n - j + 1) for j in 1:n, i in 1:n]
twodiagonalmat (generic function with 1 method)

julia> twodiagonalmat(1)
1×1 Matrix{Int64}:
 1

julia> twodiagonalmat(2)
2×2 Matrix{Int64}:
 1  1
 1  1

julia> twodiagonalmat(3)
3×3 Matrix{Int64}:
 1  0  1
 0  1  0
 1  0  1

julia> twodiagonalmat(4)
4×4 Matrix{Int64}:
 1  0  0  1
 0  1  1  0
 0  1  1  0
 1  0  0  1

julia> twodiagonalmat(5)
5×5 Matrix{Int64}:
 1  0  0  0  1
 0  1  0  1  0
 0  0  1  0  0
 0  1  0  1  0
 1  0  0  0  1
