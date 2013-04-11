// Default Construction with explicit property setting:
def p0 = new Point()
assert 0 == p0.x
assert 0 == p0.y
p0.x = 36
p0.y = -2
assert 36 == p0.x
assert -2 == p0.y

// Direct Construction:
def p1 = new Point(36, -2)
assert 36 == p1.x
assert -2 == p1.y

def p2 = new Point(36)
assert 36 == p2.x
assert 0 == p2.y
