using LinearAlgebra

a = [25 15 5; 15 18 0; -5 0 11]
b = [18 22 54 22; 22 70 86 62; 54 86 174 134; 42 62 134 106]

println(a, "\n => \n", cholesky(Symmetric(a, :L)))
println(b, "\n => \n", cholesky(Symmetric(b, :L)))
