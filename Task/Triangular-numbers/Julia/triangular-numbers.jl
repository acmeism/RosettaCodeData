""" rosettacode.org task Triangular_numbers """


polytopic(r, range) = map(n -> binomial(n + r - 1, r), range)

triangular_root(x) = (sqrt(8x + 1) - 1) / 2

function tetrahedral_root(x)
    return Float64(round((3x + sqrt(9 * x^big"2" - big"1"/27))^(big"1"/3) +
       (3x - sqrt(9 * x^big"2" - big"1"/27))^(big"1"/3) - 1, digits=18))
end

pentatopic_root(x) = (sqrt(5 + 4 * sqrt(24x + 1)) - 3) / 2

function valuelisting(a, N=6)
    c = maximum(length, string.(a)) + 1
    return join([join([lpad(x, c) for x in v]) for v in Iterators.partition(a, N)], "\n")
end

for (r, name) in [[2, "triangular"], [3, "tetrahedral"], [4, "pentatopic"], [12, "12-simplex"]]
    println("\nFirst 30 $name numbers:\n", valuelisting(polytopic(r, 0:29)))
end

for n in [7140, 21408696, 26728085384, 14545501785001]
    println("\nRoots of $n:")
    println("   triangular-root: ", triangular_root(n))
    println("   tetrahedral-root: ", tetrahedral_root(n))
    println("   pentatopic-root: ", pentatopic_root(n))
end
