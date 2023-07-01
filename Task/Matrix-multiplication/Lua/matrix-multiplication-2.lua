local alg = require("sci.alg")
mat1 = alg.tomat{{1, 2, 3}, {4, 5, 6}}
mat2 = alg.tomat{{1, 2}, {3, 4}, {5, 6}}
mat3 = mat1[] ** mat2[]
print(mat3)
