import "./fmt" for Fmt

var aitken = Fn.new { |f, p0|
    var p1 = f.call(p0)
    var p2 = f.call(p1)
    var p1m0 = p1 - p0
    return p0 - p1m0 * p1m0 / (p2 - 2 * p1 + p0)
}

var steffensenAitken = Fn.new { |f, pinit, tol, maxiter|
    var p0 = pinit
    var p = aitken.call(f, p0)
    var iter = 1
    while ((p - p0).abs > tol && iter < maxiter) {
        p0 = p
        p = aitken.call(f, p0)
        iter = iter + 1
    }
    if ((p - p0).abs > tol) return null
    return p
}

var deCasteljau = Fn.new { |c0, c1, c2, t|
    var s = 1 - t
    var c01 = s * c0 + t * c1
    var c12 = s * c1 + t * c2
    return s * c01 + t * c12
}

var xConvexLeftParabola  = Fn.new { |t| deCasteljau.call(2, -8, 2, t) }
var yConvexRightParabola = Fn.new { |t| deCasteljau.call(1,  2, 3, t) }

var implicitEquation = Fn.new { |x, y|  5 * x * x + y - 5 }

var f = Fn.new { |t|
    var x = xConvexLeftParabola.call(t)
    var y = yConvexRightParabola.call(t)
    return implicitEquation.call(x, y) + t
}

var t0 = 0
for (i in 0..10) {
    Fmt.write("t0 = $0.1f : ", t0)
    var t = steffensenAitken.call(f, t0, 0.00000001, 1000)
    if (!t) {
        Fmt.print("no answer")
    } else {
        var x = xConvexLeftParabola.call(t)
        var y = yConvexRightParabola.call(t)
        if (implicitEquation.call(x, y).abs <= 0.000001) {
            Fmt.print("intersection at ($f, $f)", x, y)
        } else {
            Fmt.print("spurious solution")
        }
    }
    t0 = t0 + 0.1
}
