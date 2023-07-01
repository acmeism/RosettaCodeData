// Direct map-based construction
def p3 = new Point([x: 36, y: -2])
assert 36 == p3.x
assert -2 == p3.y

// Direct map-entry-based construction
p3 = new Point(x: 36, y: -2)
assert 36 == p3.x
assert -2 == p3.y

p3 = new Point(x: 36)
assert 36 == p3.x
assert 0 == p3.y

p3 = new Point(y: -2)
assert 0 == p3.x
assert -2 == p3.y

// Explicit coercion from map with "as" keyword
def p5 = [x: 36, y: -2] as Point
assert 36 == p5.x
assert -2 == p5.y

// Implicit coercion from map (by type of variable)
Point p7 = [x: 36, y: -2]
assert 36 == p7.x
assert -2 == p7.y

Point p9 = [y:-2]
assert 0 == p9.x
assert -2 == p9.y
