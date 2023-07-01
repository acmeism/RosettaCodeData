class Vector3D {
    construct new(x, y, z) {
        if (x.type != Num  || y.type != Num || z.type != Num)  Fiber.abort("Arguments must be numbers.")
        _x = x
        _y = y
        _z = z
    }

    x { _x }
    y { _y }
    z { _z }

    dot(v) {
        if (v.type != Vector3D) Fiber.abort("Argument must be a Vector3D.")
        return _x * v.x + _y * v.y + _z * v.z
    }

    cross(v) {
        if (v.type != Vector3D) Fiber.abort("Argument must be a Vector3D.")
        return Vector3D.new(_y*v.z - _z*v.y, _z*v.x - _x*v.z, _x*v.y - _y*v.x)
    }

    scalarTriple(v, w) {
        if ((v.type != Vector3D) || (w.type != Vector3D)) Fiber.abort("Arguments must be Vector3Ds.")
        return this.dot(v.cross(w))
    }

    vectorTriple(v, w) {
        if ((v.type != Vector3D) || (w.type != Vector3D)) Fiber.abort("Arguments must be Vector3Ds.")
        return this.cross(v.cross(w))
    }

    toString { [_x, _y, _z].toString }
}

var a = Vector3D.new(3, 4, 5)
var b = Vector3D.new(4, 3, 5)
var c = Vector3D.new(-5, -12, -13)
System.print("a = %(a)")
System.print("b = %(b)")
System.print("c = %(c)")
System.print()
System.print("a . b     = %(a.dot(b))")
System.print("a x b     = %(a.cross(b))")
System.print("a . b x c = %(a.scalarTriple(b, c))")
System.print("a x b x c = %(a.vectorTriple(b, c))")
