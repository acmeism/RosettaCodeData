import "./matrix" for Matrix
import "./fmt" for Fmt

var minor = Fn.new { |x, d|
    var nr = x.numRows
    var nc = x.numCols
    var m = Matrix.new(nr, nc)
    for (i in 0...d) m[i, i] = 1
    for (i in d...nr) {
        for (j in d...nc) m[i, j] = x[i, j]
    }
    return m
}

var vmadd = Fn.new { |a, b, s|
    var n = a.count
    var c = List.filled(n, 0)
    for (i in 0...n) c[i] = a[i] + s * b[i]
    return c
}

var vmul = Fn.new { |v|
    var n = v.count
    var x = Matrix.new(n, n)
    for (i in 0...n) {
        for (j in 0...n) x[i, j] = -2 * v[i] * v[j]
    }
    for (i in 0...n) x[i, i] = x[i, i] + 1
    return x
}

var vnorm = Fn.new { |x|
    var n = x.count
    var sum = 0
    for (i in 0...n) sum = sum + x[i] * x[i]
    return sum.sqrt
}

var vdiv = Fn.new { |x, d|
    var n = x.count
    var y = List.filled(n, 0)
    for (i in 0...n) y[i] = x[i] / d
    return y
}

var mcol = Fn.new { |m, c|
    var n = m.numRows
    var v = List.filled(n, 0)
    for (i in 0...n) v[i] = m[i, c]
    return v
}

var householder = Fn.new { |m|
    var nr = m.numRows
    var nc = m.numCols
    var q = List.filled(nr, null)
    var z = m.copy()
    var k = 0
    while (k < nc && k < nr-1) {
       var e = List.filled(nr, 0)
       z = minor.call(z, k)
       var x = mcol.call(z, k)
       var a = vnorm.call(x)
       if (m[k, k] > 0) a = -a
       for (i in 0...nr) e[i] = (i == k) ? 1 : 0
       e = vmadd.call(x, e, a)
       e = vdiv.call(e, vnorm.call(e))
       q[k] = vmul.call(e)
       z = q[k] * z
       k = k + 1
    }
    var Q = q[0]
    var R = q[0] * m
    var i = 1
    while (i < nc && i < nr-1) {
        Q = q[i] * Q
        i = i + 1
    }
    R = Q * m
    Q = Q.transpose
    return [Q, R]
}

var inp = [
    [12, -51,   4],
	[ 6, 167, -68],
	[-4,  24, -41],
	[-1,   1,   0],
	[ 2,   0,   3]
]
var x = Matrix.new(inp)
var res = householder.call(x)
var Q = res[0]
var R = res[1]
var m = Q * R
System.print("Q:")
Fmt.mprint(Q, 8, 3)
System.print("\nR:")
Fmt.mprint(R, 8, 3)
System.print("\nQ * R:")
Fmt.mprint(m, 8, 3)
