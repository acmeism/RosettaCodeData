julia> [binomial(j,i) for i in 0:4, j in 0:4]
5×5 Array{Int64,2}:
 1  1  1  1  1
 0  1  2  3  4
 0  0  1  3  6
 0  0  0  1  4
 0  0  0  0  1

julia> [binomial(i,j) for i in 0:4, j in 0:4]
5×5 Array{Int64,2}:
 1  0  0  0  0
 1  1  0  0  0
 1  2  1  0  0
 1  3  3  1  0
 1  4  6  4  1

julia> [binomial(j+i,i) for i in 0:4, j in 0:4]
5×5 Array{Int64,2}:
 1  1   1   1   1
 1  2   3   4   5
 1  3   6  10  15
 1  4  10  20  35
 1  5  15  35  70
