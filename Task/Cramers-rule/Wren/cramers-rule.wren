import "/matrix" for Matrix

var cramer = Fn.new { |a, d|
    var n = a.numRows
    var x = List.filled(n, 0)
    var ad = a.det
    for (c in 0...n) {
        var aa = a.copy()
        for (r in 0...n) aa[r, c] = d[r, 0]
        x[c] = aa.det/ad
    }
    return x
}

var a = Matrix.new([
    [2, -1,  5,  1],
    [3,  2,  2, -6],
    [1,  3,  3, -1],
    [5, -2, -3,  3]
])

var d = Matrix.new([
    [- 3],
    [-32],
    [-47],
    [ 49]
])

var x = cramer.call(a, d)
System.print("Solution is %(x)")
