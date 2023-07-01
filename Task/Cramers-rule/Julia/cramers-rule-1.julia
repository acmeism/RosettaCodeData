function cramersolve(A::Matrix, b::Vector)
    return collect(begin B = copy(A); B[:, i] = b; det(B) end for i in eachindex(b)) ./ det(A)
end

A = [2 -1  5  1
     3  2  2 -6
     1  3  3 -1
     5 -2 -3  3]

b = [-3, -32, -47, 49]

@show cramersolve(A, b)
