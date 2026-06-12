julia> Numbers1 = [5,45,23,21,67]
5-element Vector{Int64}:
  5
 45
 23
 21
 67

julia> Numbers2 = [43,22,78,46,38]
5-element Vector{Int64}:
 43
 22
 78
 46
 38

julia> Numbers3 = [9,98,12,98,53]
5-element Vector{Int64}:
  9
 98
 12
 98
 53

julia> mat = hcat(Numbers1, Numbers2, Numbers3)
5×3 Matrix{Int64}:
  5  43   9
 45  22  98
 23  78  12
 21  46  98
 67  38  53

julia> minimum(mat, dims=2)
5×1 Matrix{Int64}:
  5
 22
 12
 21
 38
