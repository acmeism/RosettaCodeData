pyth = (n) -> flatten (flatten ([x, y, z] for z in [y..n] when x*x + y*y is z*z for y in [x..n]) for x in [1..n])
