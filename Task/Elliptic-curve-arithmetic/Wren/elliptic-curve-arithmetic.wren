import "./fmt" for Fmt

var C = 7

class Pt {
    static zero { Pt.new(1/0, 1/0) }

    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    static fromNum(n) { Pt.new((n*n - C).cbrt, n) }

    isZero { x > 1e20 || x < -1e20 }

    double {
        if (isZero) return this
        var l = 3 * x * x / (2 * y)
        var t = l*l - 2*x
        return Pt.new(t, l*(x - t) - y)
    }

    - { Pt.new(x, -y) }

    +(other) {
        if (other.type != Pt) Fiber.abort("Argument must be a Pt object.")
        if (x == other.x && y == other.y) return double
        if (isZero) return other
        if (other.isZero) return this
        var l = (other.y - y) / (other.x - x)
        var t = l*l - x - other.x
        return Pt.new(t, l*(x-t) - y)
    }

    *(n) {
        if (n.type != Num || !n.isInteger) {
            Fiber.abort("Argument must be an integer.")
        }
        var r = Pt.zero
        var p = this
        var i = 1
        while (i <= n) {
            if ((i & n) != 0) r = r + p
            p = p.double
            i = i << 1
        }
        return r
    }

    toString { isZero ? "Zero" : Fmt.swrite("($0.3f, $0.3f)", x, y) }
}

var a = Pt.fromNum(1)
var b = Pt.fromNum(2)
var c = a + b
var d = -c
System.print("a         = %(a)")
System.print("b         = %(b)")
System.print("c = a + b = %(c)")
System.print("d = -c    = %(d)")
System.print("c + d     = %(c + d)")
System.print("a + b + d = %(a + b + d)")
System.print("a * 12345 = %(a * 12345)")
