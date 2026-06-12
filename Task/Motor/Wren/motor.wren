import "./vector" for Vector3

// Vector3 class only defines multiplication by a scalar.
var Vmul = Fn.new { |v1, v2|
    return Vector3.new(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z)
}

class Quat {
    construct new(v3, w) {
        if (!(v3 is Vector3)) Fiber.abort("Argument #1 must be a Vector3.")
        if (!(w is Num)) Fiber.abort("Argument #2 must be a Num.")
        _x = v3.x
        _y = v3.y
        _z = v3.z
        _w = w
    }

    x { _x }
    y { _y }
    z { _z }
    w { _w }

    toString { "(%(_x), %(_y), %(_z), %(_w))" }
}

class Motor {
    static cross3(a, b) {
        if (!(a is Motor)) Fiber.abort("Argument #1 must be a Motor.")
        if (!(b is Motor)) Fiber.abort("Argument #2 must be a Motor.")
        var a1 = Vector3.new(a.rotor.y, a.rotor.z, a.rotor.x)
        var a2 = Vector3.new(a.rotor.z, a.rotor.x, a.rotor.y)
        var b1 = Vector3.new(b.rotor.y, b.rotor.z, b.rotor.x)
        var b2 = Vector3.new(b.rotor.z, b.rotor.x, b.rotor.y)
        return Quat.new(Vmul.call(a1, b2) - Vmul.call(a2, b1), 0)
    }

    construct new(rotor, screw) {
        if (!(rotor is Quat)) Fiber.abort("Argument #1 must be a Quat.")
        if (!(screw is Quat)) Fiber.abort("Argument #2 must be a Quat.")
        _r = rotor
        _s = screw
    }

    rotor { _r }
    screw { _s }

    toString { "(%(_r), %(_s))" }
}

var vec1 = Vector3.new(1, 2, 3)
var w1   = 4
var q1   = Quat.new(vec1, w1)
var vec2 = Vector3.new(5, 6, 7)
var w2   = 8
var q2   = Quat.new(vec2, w2)
var vec3 = Vector3.new(0, 0, 0)
var w3   = 0
var q3   = Quat.new(vec3, w3)
var m1   = Motor.new(q1, q3)
var m2   = Motor.new(q2, q3)
System.print("m1: %(m1)")
System.print("m2: %(m2)")
System.print("m1 x m2 = %(Motor.cross3(m1, m2))")
