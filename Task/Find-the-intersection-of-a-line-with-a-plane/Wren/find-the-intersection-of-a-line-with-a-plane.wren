import "./vector" for Vector3

var intersectPoint = Fn.new { |rayVector, rayPoint, planeNormal, planePoint|
    var diff  = rayPoint - planePoint
    var prod1 = diff.dot(planeNormal)
    var prod2 = rayVector.dot(planeNormal)
    var prod3 = prod1 / prod2
    return rayPoint - rayVector*prod3
}

var rv = Vector3.new(0, -1, -1)
var rp = Vector3.new(0,  0, 10)
var pn = Vector3.new(0,  0,  1)
var pp = Vector3.new(0,  0,  5)
var ip = intersectPoint.call(rv, rp, pn, pp)
System.print("The ray intersects the plane at %(ip).")
