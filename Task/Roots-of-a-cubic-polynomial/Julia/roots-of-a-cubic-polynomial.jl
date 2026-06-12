using LinearAlgebra

""" Cubic polynomial using Horner's method. """
horner(xarr, a, b, c, d) = @. ((a * xarr + b) * xarr + c) * xarr + d

""" Get parameters of characteristic cubic polynomial (with x^3 term 1) from 3x3 matrix """
polynomial3(t) = (1, -tr(t), (tr(t)^2 - tr(t^2)) / 2, -det(t)) # a, b, c, d

# test values
const sin45 = 1 / sqrt(2)
const testmats = [
    [1 -1  0; 0 1 1; 0 0 1],
    [-2 -4 2; -2 1 2; 4 2 5],
    [1 -1 0; 0 1 -1; 0 0 1],
    [2 0 0; 0 -1 0; 0 0 -1],
    [2 0 0; 0 3 4; 0 4 9],
    [1 0 0; 0 sin45 -sin45; 0 sin45 sin45],
]

for mat in testmats
    display(mat)
    a, b, c, d = polynomial3(mat)
    print("The characteristic polynomial is: ")
    println("x³ ", b < 0 ? "- $(-b)" : " + $b", "x^² ", c < 0 ? "- $(-c)" : "+ $c", "x ",
       d < 0 ? "- $(-d)" : "+ $d")
    evals = eigvals(mat)
    println("The LAPACK library computed eigenvalues are: $evals")
    println("Errors are: ", horner(evals, a, b, c, d), "\n")
end
