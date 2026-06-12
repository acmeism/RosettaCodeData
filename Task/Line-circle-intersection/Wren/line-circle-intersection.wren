import "./dynamic" for Tuple

var Point = Tuple.create("Point", ["x", "y"])

var eps = 1e-14

var intersects = Fn.new { |p1, p2, cp, r, segment|
    var res = []
    var x0 = cp.x
    var y0 = cp.y
    var x1 = p1.x
    var y1 = p1.y
    var x2 = p2.x
    var y2 = p2.y
    var A = y2 - y1
    var B = x1 - x2
    var C = x2 * y1 - x1 * y2
    var a = A * A + B * B
    var b
    var c
    var bnz = true
    if (B.abs >= eps) {
        b = 2 * (A * C + A * B * y0 - B * B * x0)
        c = C * C + 2 * B * C * y0 - B * B * (r * r - x0 * x0 - y0 * y0)
    } else {
        b = 2 * (B * C + A * B * x0 - A * A * y0)
        c = C * C + 2 * A * C * x0 - A * A * (r * r - x0 * x0 - y0 * y0)
        bnz = false
    }
    var d = b * b - 4 * a * c // discriminant
    if (d < 0) {
        return "[]"
    }

    // checks whether a point is within a segment
    var within = Fn.new { |x0, y0|
        var d1 = ((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1)).sqrt  // distance between end-points
        var d2 = ((x0 - x1)*(x0 - x1) + (y0 - y1)*(y0 - y1)).sqrt  // distance from point to one end
        var d3 = ((x2 - x0)*(x2 - x0) + (y2 - y0)*(y2 - y0)).sqrt  // distance from point to other end
        var delta = d1 - d2 - d3
        return delta.abs < eps // true if delta is less than a small tolerance
    }

    var x = 0
    var fx = Fn.new { -(A * x + C) / B }

    var y = 0
    var fy = Fn.new { -(B * y + C) / A }

    var rxy = Fn.new {
        if (!segment || within.call(x, y)) {
            res.add(Point.new(x, y))
        }
    }

    if (d == 0) {
        // line is tangent to circle, so just one intersect at most
        if (bnz) {
            x = -b / (2 * a)
            y = fx.call()
        } else {
            y = -b / (2 * a)
            x = fy.call()
        }
        rxy.call()
    } else {
        // two intersects at most
        d = d.sqrt
        if (bnz) {
            x = (-b + d) / (2 * a)
            y = fx.call()
            rxy.call()
            x = (-b - d) / (2 * a)
            y = fx.call()
            rxy.call()
        } else {
            y = (-b + d) / (2 * a)
            x = fy.call()
            rxy.call()
            y = (-b - d) / (2 * a)
            x = fy.call()
            rxy.call()
        }
    }

    // get rid of any negative zeros and return as a string
    return res.toString.replace("-0,", "0,").replace("-0]", "0]")
}

System.print("The intersection points (if any) between:")

var cp = Point.new(3, -5)
var r = 3
System.print("  A circle, center %(cp) with radius %(r), and:")

var p1 = Point.new(-10, 11)
var p2 = Point.new( 10, -9)
System.print("    a line containing the points %(p1) and %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, false))")

p2 = Point.new(-10, 12)
System.print("    a segment starting at %(p1) and ending at %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, true))")

p1 = Point.new(3, -2)
p2 = Point.new(7, -2)
System.print("    a horizontal line containing the points %(p1) and %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, false))")

cp = Point.new(0, 0)
r = 4
System.print("  A circle, center %(cp) with radius %(r), and:")

p1 = Point.new(0, -3)
p2 = Point.new(0,  6)
System.print("    a vertical line containing the points %(p1) and %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, false))")
System.print("    a vertical segment containing the points %(p1) and %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, true))")

cp = Point.new(4, 2)
r = 5
System.print("  A circle, center %(cp) with radius %(r), and:")

p1 = Point.new( 6, 3)
p2 = Point.new(10, 7)
System.print("    a line containing the points %(p1) and %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, false))")

p1 = Point.new( 7, 4)
p2 = Point.new(11, 8)
System.print("    a segment starting at %(p1) and ending at %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, true))")

cp = Point.new(10, 10)
r = 5
System.print("  A circle, center %(cp) with radius %(r), and:")

p1 = Point.new( 5,  0)
p2 = Point.new( 5, 20)
System.print("    a vertical line containing the points %(p1) and %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, false))")

p1 = Point.new(-5, 10)
p2 = Point.new( 5, 10)
System.print("    a horizontal segment starting at %(p1) and ending at %(p2) is/are:")
System.print("     %(intersects.call(p1, p2, cp, r, true))")
