Point(x, y) = [x, y]
Triangle(a, b, c) = [a, b, c]
LEzero(x) =  x < 0 || isapprox(x, 0, atol=0.00000001)
GEzero(x) =  x > 0 || isapprox(x, 0, atol=0.00000001)

""" Determine which side of plane cut by line (p2, p3) p1 is on """
side(p1, p2, p3) = (p1[1] - p3[1]) * (p2[2] - p3[2]) - (p2[1] - p3[1]) * (p1[2] - p3[2])

"""
Determine if point is within triangle formed by points p1, p2, p3.
If so, the point will be on the same side of each of the half planes
defined by vectors p1p2, p2p3, and p3p1. Each z is positive if outside,
negative if inside such a plane. All should be positive or all negative
if point is within the triangle.
"""
function iswithin(point, p1, p2, p3)
    z1 = side(point, p1, p2)
    z2 = side(point, p2, p3)
    z3 = side(point, p3, p1)
    notanyneg = GEzero(z1) && GEzero(z2) && GEzero(z3)
    notanypos = LEzero(z1) && LEzero(z2) && LEzero(z3)
    return notanyneg || notanypos
end

const POINTS = [Point(0 // 1, 0 // 1), Point(0 // 1, 1 // 1), Point(3 // 1, 1 // 1),
    Point(1 // 10 + (3 // 7) * (100 // 8 - 1 // 10), 1 // 9 + (3 // 7) * (100 // 3 - 1 // 9)),
    Point(3 // 2, 12 // 5), Point(51 // 100, -31 // 100), Point(-19 // 50, 6 // 5),
    Point(1 // 10, 1 // 9), Point(25 / 2, 100 // 3), Point(25, 100 // 9),
    Point(-25 // 2, 50 // 3)
]

const TRI = [
    Triangle(POINTS[5], POINTS[6], POINTS[7]),
    Triangle(POINTS[8], POINTS[9], POINTS[10]),
    Triangle(POINTS[8], POINTS[9], POINTS[11])
]

for tri in TRI
    pstring(pt) = "[$(Float32(pt[1])), $(Float32(pt[2]))]"
    println("\nUsing triangle [", join([pstring(x) for x in tri], ", "), "]:")
    a, b, c = tri[1], tri[2], tri[3]
    for p in POINTS[1:4]
        isornot = iswithin(p, a, b, c) ? "is" : "is not"
        println("Point $(pstring(p)) $isornot within the triangle.")
    end
end
