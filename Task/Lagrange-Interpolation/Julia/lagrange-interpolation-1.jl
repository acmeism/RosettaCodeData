using Polynomials, SpecialPolynomials

const pts = [[1, 1], [2, 4], [3, 1], [4, 5]]
const xs = first.(pts)
const ys = last.(pts)
const p = Lagrange(xs, ys)

@show p Polynomial(p)
