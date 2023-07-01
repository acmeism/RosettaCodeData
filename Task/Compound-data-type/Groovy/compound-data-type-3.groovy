// Explicit coersion from list with "as" keyword
def p4 = [36, -2] as Point
assert 36 == p4.x
assert -2 == p4.y

// Explicit coersion from list with Java/C-style casting
p4 = (Point) [36, -2]
println p4
assert 36 == p4.x
assert -2 == p4.y

// Implicit coercion from list (by type of variable)
Point p6 = [36, -2]
assert 36 == p6.x
assert -2 == p6.y

Point p8 = [36]
assert 36 == p8.x
assert 0 == p8.y
