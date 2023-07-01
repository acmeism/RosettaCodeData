class Vector2D {
    construct new(x, y) {
        _x = x
        _y = y
    }

    static fromPolar(r, theta) { new(r * theta.cos, r * theta.sin) }

    x { _x }
    y { _y }

    +(v) { Vector2D.new(_x + v.x, _y + v.y) }
    -(v) { Vector2D.new(_x - v.x, _y - v.y) }
    *(s) { Vector2D.new(_x * s,   _y * s) }
    /(s) { Vector2D.new(_x / s,   _y / s) }

    toString { "(%(_x), %(_y))" }
}

var times = Fn.new { |d, v| v * d }

var v1 = Vector2D.new(5, 7)
var v2 = Vector2D.new(2, 3)
var v3 = Vector2D.fromPolar(2.sqrt, Num.pi / 4)
System.print("v1 = %(v1)")
System.print("v2 = %(v2)")
System.print("v3 = %(v3)")
System.print()
System.print("v1 + v2 = %(v1 + v2)")
System.print("v1 - v2 = %(v1 - v2)")
System.print("v1 * 11 = %(v1 * 11)")
System.print("11 * v2 = %(times.call(11, v2))")
System.print("v1 / 2  = %(v1 /  2)")
