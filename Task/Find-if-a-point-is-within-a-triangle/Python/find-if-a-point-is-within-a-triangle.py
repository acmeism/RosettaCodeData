""" find if point is in a triangle """

from sympy.geometry import Point, Triangle

def sign(pt1, pt2, pt3):
    """ which side of plane cut by line (pt2, pt3) is pt1 on? """
    return (pt1.x - pt3.x) * (pt2.y - pt3.y) - (pt2.x - pt3.x) * (pt1.y - pt3.y)


def iswithin(point, pt1, pt2, pt3):
    """
    Determine if point is within triangle formed by points p1, p2, p3.
    If so, the point will be on the same side of each of the half planes
    defined by vectors p1p2, p2p3, and p3p1. zval is positive if outside,
    negative if inside such a plane. All should be positive or all negative
    if point is within the triangle.
    """
    zval1 = sign(point, pt1, pt2)
    zval2 = sign(point, pt2, pt3)
    zval3 = sign(point, pt3, pt1)
    notanyneg = zval1 >= 0 and zval2 >= 0 and zval3 >= 0
    notanypos = zval1 <= 0 and zval2 <= 0 and zval3 <= 0
    return notanyneg or notanypos

if __name__ == "__main__":
    POINTS = [Point(0, 0)]
    TRI = Triangle(Point(1.5, 2.4), Point(5.1, -3.1), Point(-3.8, 0.5))
    for pnt in POINTS:
        a, b, c = TRI.vertices
        isornot = "is" if iswithin(pnt, a, b, c) else "is not"
        print("Point", pnt, isornot, "within the triangle", TRI)
