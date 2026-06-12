using Polynomials

testcases = [
    ("5", [5]),
    ("-3x+4", [4, -3]),
    ("5x2+6x-1", [-1, 6, 5]),
    ("x3-2x2+3x-4", [-4, 3, -2, 1]),
    ("-x4-x3+x+1", [1, 1, 0, -1, -1]),
]

for (s, coef) in testcases
    println("Derivative of $s: ", derivative(Polynomial(coef)))
end
