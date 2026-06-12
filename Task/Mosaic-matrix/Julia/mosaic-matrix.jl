julia> mosaicmat(n) = (m = n + iseven(n); reshape([Int(isodd(i)) for i in 1:m^2], m, m)[1:n, 1:n])
mosaicmat (generic function with 1 method)

julia> mosaicmat(1)
1×1 Matrix{Int64}:
 1

julia> mosaicmat(2)
2×2 Matrix{Int64}:
 1  0
 0  1

julia> mosaicmat(3)
3×3 Matrix{Int64}:
 1  0  1
 0  1  0
 1  0  1

julia> mosaicmat(4)
4×4 Matrix{Int64}:
 1  0  1  0
 0  1  0  1
 1  0  1  0
 0  1  0  1

julia> mosaicmat(5)
5×5 Matrix{Int64}:
 1  0  1  0  1
 0  1  0  1  0
 1  0  1  0  1
 0  1  0  1  0
 1  0  1  0  1
