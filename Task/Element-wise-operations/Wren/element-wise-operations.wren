import "/fmt" for Fmt
import "/matrix" for Matrix

// matrix-matrix element wise ops
class MM {
    static add(m1, m2) { m1 + m2 }
    static sub(m1, m2) { m1 - m2 }

    static mul(m1, m2) {
        if (!m1.sameSize(m2)) Fiber.abort("Matrices must be of the same size.")
        var m = Matrix.new(m1.numRows, m1.numCols)
        for (i in 0...m.numRows) {
            for (j in 0...m.numCols) m[i, j] = m1[i, j] * m2[i, j]
        }
        return m
    }

    static div(m1, m2) {
        if (!m1.sameSize(m2)) Fiber.abort("Matrices must be of the same size.")
        var m = Matrix.new(m1.numRows, m1.numCols)
        for (i in 0...m.numRows) {
            for (j in 0...m.numCols) m[i, j] = m1[i, j] / m2[i, j]
        }
        return m
    }

    static pow(m1, m2) {
        if (!m1.sameSize(m2)) Fiber.abort("Matrices must be of the same size.")
        var m = Matrix.new(m1.numRows, m1.numCols)
        for (i in 0...m.numRows) {
            for (j in 0...m.numCols) m[i, j] = m1[i, j].pow(m2[i, j])
        }
        return m
    }
}

// matrix-scalar element wise ops
class MS {
    static add(m, s) { m + s }
    static sub(m, s) { m - s }
    static mul(m, s) { m * s }
    static div(m, s) { m / s }
    static pow(m, s) { m.apply { |e| e.pow(s) } }
}

// scalar-matrix element wise ops
class SM {
    static add(s, m) {  m + s }
    static sub(s, m) { -m + s }
    static mul(s, m) {  m * s }

    static div(s, m) {
        var n = Matrix.new(m.numRows, m.numCols)
        for (i in 0...n.numRows) {
            for (j in 0...n.numCols) n[i, j] = s / m[i, j]
        }
        return n
    }

    static pow(s, m) {
        var n = Matrix.new(m.numRows, m.numCols)
        for (i in 0...n.numRows) {
            for (j in 0...n.numCols) n[i, j] = s.pow(m[i, j])
        }
        return n
    }
}

var m = Matrix.new([ [3, 5, 7], [1, 2, 3], [2, 4, 6] ])
System.print("m:")
Fmt.mprint(m, 2, 0)
System.print("\nm + m:")
Fmt.mprint(MM.add(m, m), 2, 0)
System.print("\nm - m:")
Fmt.mprint(MM.sub(m, m), 2, 0)
System.print("\nm * m:")
Fmt.mprint(MM.mul(m, m), 2, 0)
System.print("\nm / m:")
Fmt.mprint(MM.div(m, m), 2, 0)
System.print("\nm ^ m:")
Fmt.mprint(MM.pow(m, m), 6, 0)

var s = 2
System.print("\ns = %(s):")
System.print("\nm + s:")
Fmt.mprint(MS.add(m, s), 2, 0)
System.print("\nm - s:")
Fmt.mprint(MS.sub(m, s), 2, 0)
System.print("\nm * s:")
Fmt.mprint(MS.mul(m, s), 2, 0)
System.print("\nm / s:")
Fmt.mprint(MS.div(m, s), 3, 1)
System.print("\nm ^ s:")
Fmt.mprint(MS.pow(m, s), 2, 0)

System.print("\ns + m:")
Fmt.mprint(SM.add(s, m), 2, 0)
System.print("\ns - m:")
Fmt.mprint(SM.sub(s, m), 2, 0)
System.print("\ns * m:")
Fmt.mprint(SM.mul(s, m), 2, 0)
System.print("\ns / m:")
Fmt.mprint(SM.div(s, m), 8, 6)
System.print("\ns ^ m:")
Fmt.mprint(SM.pow(s, m), 3, 0)
