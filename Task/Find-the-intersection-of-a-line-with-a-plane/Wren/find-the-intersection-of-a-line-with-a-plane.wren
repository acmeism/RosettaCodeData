class Vector3D {
    construct new(x, y, z) {
        _x = x
        _y = y
        _z = z
    }

    x { _x }
    y { _y }
    z { _z }

    +(v) { Vector3D.new(_x + v.x, _y + v.y, _z + v.z) }

    -(v) { Vector3D.new(_x - v.x, _y - v.y, _z - v.z) }

    *(s) { Vector3D.new(s * _x, s * _y, s * _z) }

    dot(v) { _x * v.x + _y * v.y + _z * v.z }

    toString { "(%(_x), %(_y), %(_z))" }
}

var intersectPoint = Fn.new { |rayVector, rayPoint, planeNormal, planePoint|
    var diff  = rayPoint - planePoint
    var prod1 = diff.dot(planeNormal)
    var prod2 = rayVector.dot(planeNormal)
    var prod3 = prod1 / prod2
    return rayPoint - rayVector*prod3
}

var rv = Vector3D.new(0, -1, -1)
var rp = Vector3D.new(0,  0, 10)
var pn = Vector3D.new(0,  0,  1)
var pp = Vector3D.new(0,  0,  5)
var ip = intersectPoint.call(rv, rp, pn, pp)
System.print("The ray intersects the plane at %(ip).")
