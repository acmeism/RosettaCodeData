using GeometryTypes

a = LineSegment(Point2f0(4, 0), Point2f0(6, 10))
b = LineSegment(Point2f0(0, 3), Point2f0(10, 7))
@show intersects(a, b)   # --> intersects(a, b) = (true, Float32[5.0, 5.0])
