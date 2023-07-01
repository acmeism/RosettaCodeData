# v0.6

linearcombination(coef::Array) = join(collect("$c * e($i)" for (i, c) in enumerate(coef) if c != 0), " + ")

for c in [[1, 2, 3], [0, 1, 2, 3], [1, 0, 3, 4], [1, 2, 0], [0, 0, 0], [0], [1, 1, 1],
    [-1, -1, -1], [-1, -2, 0, -3], [-1]]
    @printf("%20s -> %s\n", c, linearcombination(c))
end
