import math

eps = 1e-14


class Point:
    def __init__(self, x: float, y: float):
        self.x = float(x)
        self.y = float(y)

    def __repr__(self):
        nx = self.x + 0.0 if abs(self.x) < 1e-15 else self.x
        ny = self.y + 0.0 if abs(self.y) < 1e-15 else self.y
        return f"Point({nx},{ny})"

    def __iter__(self):
        yield self.x
        yield self.y


def sq(x: float) -> float:
    return x**2


def intersects(
    p1: Point, p2: Point, cp: Point, radius: float, is_segment: bool = False
):
    """
    Finds the intersection points (if any) of a circle, center 'cp' with radius 'r',
    and either an infinite line containing the points 'p1' and 'p2'
    or a segment drawn between those points.
    """

    def add_intersection(x: float, y: float, is_segment: bool = False):
        if not is_segment or within(x, y):
            intersections.append(Point(x, y))

    def within(x: float, y: float) -> bool:

        d1 = math.hypot(x2 - x1, y2 - y1)  # distance between end-points
        d2 = math.hypot(x - x1, y - y1)  # distance from point to one end
        d3 = math.hypot(x2 - x, y2 - y)  # distance from point to other end
        delta = d1 - d2 - d3
        return abs(delta) < eps  # true if delta is less than a small tolerance

    def fx(x: float) -> float:
        return -(A * x + C) / B

    def fy(y: float) -> float:
        return -(B * y + C) / A

    x0, y0 = cp
    x1, y1 = p1
    x2, y2 = p2

    A = y2 - y1
    B = x1 - x2
    C = x2 * y1 - x1 * y2

    a = sq(A) + sq(B)
    bnz = True

    intersections = []

    if abs(B) >= eps:
        # if B isn't zero or close to it
        b = 2 * (A * C + A * B * y0 - sq(B) * x0)
        c = sq(C) + 2 * B * C * y0 - sq(B) * (sq(radius) - sq(x0) - sq(y0))
    else:
        b = 2 * (B * C + A * B * x0 - sq(A) * y0)
        c = sq(C) + 2 * A * C * x0 - sq(A) * (sq(radius) - sq(x0) - sq(y0))
        bnz = False

    # discriminant
    discriminant = sq(b) - 4 * a * c

    if discriminant < 0:
        return intersections
    elif discriminant == 0:
        # line is tangent to circle, so just one intersect at most
        if bnz:
            x = -b / (2 * a)
            y = fx(x)
            add_intersection(x, y, is_segment)
        else:
            y = -b / (2 * a)
            x = fy(y)
            add_intersection(x, y, is_segment)
    else:
        # two intersections at most
        discriminant = math.sqrt(discriminant)
        if bnz:
            x = (-b + discriminant) / (2 * a)
            y = fx(x)
            add_intersection(x, y, is_segment)

            x = (-b - discriminant) / (2 * a)
            y = fx(x)
            add_intersection(x, y, is_segment)
        else:
            y = (-b + discriminant) / (2 * a)
            x = fy(y)
            add_intersection(x, y, is_segment)

            y = (-b - discriminant) / (2 * a)
            x = fy(y)
            add_intersection(x, y, is_segment)

    return intersections


if __name__ == "__main__":
    cp = Point(3, -5)
    r = 3.0
    print("The intersection points (if any) between:")
    print("  A circle, center (3, -5) with radius 3, and:")
    print("    a line containing the points (-10, 11) and (10, -9) is/are:")
    print(f"      {intersects(Point(-10, 11), Point(10, -9), cp, r)}")
    print("    a segment starting at (-10, 11) and ending at (-11, 12) is/are")
    print(f"      {intersects(Point(-10, 11), Point(-11, 12), cp, r, True)}")
    print("    a horizontal line containing the points (3, -2) and (7, -2) is/are:")
    print(f"      {intersects(Point(3, -2), Point(7, -2), cp, r)}")

    cp = Point(0, 0)
    r = 4.0
    print("  A circle, center (0, 0) with radius 4, and:")
    print("    a vertical line containing the points (0, -3) and (0, 6) is/are:")
    print(f"      {intersects(Point(0, -3), Point(0, 6), cp, r)}")
    print("    a vertical segment starting at (0, -3) and ending at (0, 6) is/are:")
    print(f"      {intersects(Point(0, -3), Point(0, 6), cp, r, True)}")

    cp = Point(4, 2)
    r = 5.0
    print("  A circle, center (4, 2) with radius 5, and:")
    print("    a line containing the points (6, 3) and (10, 7) is/are:")
    print(f"      {intersects(Point(6, 3), Point(10, 7), cp, r)}")
    print("    a segment starting at (7, 4) and ending at (11, 8) is/are:")
    print(f"      {intersects(Point(7, 4), Point(11, 8), cp, r, True)}")

