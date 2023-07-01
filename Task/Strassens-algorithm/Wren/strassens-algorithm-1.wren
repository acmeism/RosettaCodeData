class Matrix {
    construct new(a) {
         if (a.type != List || a.count == 0 || a[0].type != List || a[0].count == 0 || a[0][0].type != Num) {
            Fiber.abort("Argument must be a non-empty two dimensional list of numbers.")
         }
         _a  = a
    }

    rows { _a.count }
    cols { _a[0].count }

    +(b) {
        if (b.type != Matrix) Fiber.abort("Argument must be a matrix.")
        if ((this.rows != b.rows) || (this.cols != b.cols)) {
            Fiber.abort("Matrices must have the same dimensions.")
        }
        var c = List.filled(rows, null)
        for (i in 0...rows) {
            c[i] = List.filled(cols, 0)
            for (j in 0...cols) c[i][j] = _a[i][j] + b[i, j]
        }
        return Matrix.new(c)
    }

    - { this * -1 }

    -(b) { this + (-b) }

    *(b) {
        var c = List.filled(rows, null)
        if (b is Num) {
            for (i in 0...rows) {
                c[i] = List.filled(cols, 0)
                for (j in 0...cols) c[i][j] = _a[i][j] * b
            }
        } else if (b is Matrix) {
            if (this.cols != b.rows) Fiber.abort("Cannot multiply these matrices.")
            for (i in 0...rows) {
                c[i] = List.filled(b.cols, 0)
                for (j in 0...b.cols) {
                    for (k in 0...b.rows) c[i][j] = c[i][j] + _a[i][k] * b[k, j]
                }
            }
        } else {
            Fiber.abort("Argument must be a matrix or a number.")
        }
        return Matrix.new(c)
    }

    [i] { _a[i].toList }

    [i, j] { _a[i][j] }

    toString { _a.toString }

    // rounds all elements to 'p' places
    toString(p) {
        var s = List.filled(rows, "")
        var pow = 10.pow(p)
        for (i in 0...rows) {
            var t = List.filled(cols, "")
            for (j in 0...cols) {
                var r = (_a[i][j]*pow).round / pow
                t[j] = r.toString
                if (t[j] == "-0") t[j] = "0"
            }
            s[i] = t.toString
        }
        return s
    }
}

var params = Fn.new { |r, c|
    return [
        [0...r, 0...c, 0, 0],
        [0...r, c...2*c, 0, c],
        [r...2*r, 0...c, r, 0],
        [r...2*r, c...2*c, r, c]
    ]
}

var toQuarters = Fn.new { |m|
    var r = (m.rows/2).floor
    var c = (m.cols/2).floor
    var p = params.call(r, c)
    var quarters = []
    for (k in 0..3) {
        var q = List.filled(r, null)
        for (i in p[k][0]) {
            q[i - p[k][2]] = List.filled(c, 0)
            for (j in p[k][1]) q[i - p[k][2]][j - p[k][3]] = m[i, j]
        }
        quarters.add(Matrix.new(q))
    }
    return quarters
}

var fromQuarters = Fn.new { |q|
    var r = q[0].rows
    var c = q[0].cols
    var p = params.call(r, c)
    r = r * 2
    c = c * 2
    var m = List.filled(r, null)
    for (i in 0...c) m[i] = List.filled(c, 0)
    for (k in 0..3) {
        for (i in p[k][0]) {
            for (j in p[k][1]) m[i][j] = q[k][i - p[k][2], j - p[k][3]]
        }
    }
    return Matrix.new(m)
}

var strassen // recursive
strassen = Fn.new { |a, b|
    if (a.rows != a.cols || b.rows != b.cols || a.rows != b.rows) {
        Fiber.abort("Matrices must be square and of equal size.")
    }
    if (a.rows == 0 || (a.rows & (a.rows - 1)) != 0) {
        Fiber.abort("Size of matrices must be a power of two.")
    }
    if (a.rows == 1) return a * b
    var qa = toQuarters.call(a)
    var qb = toQuarters.call(b)
    var p1 = strassen.call(qa[1] - qa[3], qb[2] + qb[3])
    var p2 = strassen.call(qa[0] + qa[3], qb[0] + qb[3])
    var p3 = strassen.call(qa[0] - qa[2], qb[0] + qb[1])
    var p4 = strassen.call(qa[0] + qa[1], qb[3])
    var p5 = strassen.call(qa[0], qb[1] - qb[3])
    var p6 = strassen.call(qa[3], qb[2] - qb[0])
    var p7 = strassen.call(qa[2] + qa[3], qb[0])
    var q = List.filled(4, null)
    q[0] = p1 + p2 - p4 + p6
    q[1] = p4 + p5
    q[2] = p6 + p7
    q[3] = p2 - p3 + p5 - p7
    return fromQuarters.call(q)
}

var a = Matrix.new([ [1,2], [3, 4] ])
var b = Matrix.new([ [5,6], [7, 8] ])
var c = Matrix.new([ [1, 1, 1, 1], [2, 4, 8, 16], [3, 9, 27, 81], [4, 16, 64, 256] ])
var d = Matrix.new([ [4, -3, 4/3, -1/4], [-13/3, 19/4, -7/3, 11/24],
                     [3/2, -2, 7/6, -1/4], [-1/6, 1/4, -1/6, 1/24] ])
var e = Matrix.new([ [1, 2, 3, 4], [5, 6, 7, 8], [9,10,11,12], [13,14,15,16] ])
var f = Matrix.new([ [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1] ])
System.print("Using 'normal' matrix multiplication:")
System.print("  a * b = %(a * b)")
System.print("  c * d = %((c * d).toString(6))")
System.print("  e * f = %(e * f)")
System.print("\nUsing 'Strassen' matrix multiplication:")
System.print("  a * b = %(strassen.call(a, b))")
System.print("  c * d = %(strassen.call(c, d).toString(6))")
System.print("  e * f = %(strassen.call(e, f))")
