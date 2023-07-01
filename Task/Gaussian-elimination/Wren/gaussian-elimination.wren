import "/iterate" for Stepped

var ta = [
    [1.00, 0.00, 0.00,  0.00,  0.00,   0.00],
    [1.00, 0.63, 0.39,  0.25,  0.16,   0.10],
    [1.00, 1.26, 1.58,  1.98,  2.49,   3.13],
    [1.00, 1.88, 3.55,  6.70, 12.62,  23.80],
    [1.00, 2.51, 6.32, 15.88, 39.90, 100.28],
    [1.00, 3.14, 9.87, 31.01, 97.41, 306.02]
]

var tb = [-0.01, 0.61, 0.91, 0.99, 0.60, 0.02]

var tx = [
    -0.01, 1.602790394502114, -1.6132030599055613,
    1.2454941213714368, -0.4909897195846576, 0.065760696175232
]

var EPSILON = 1e-14  // tolerance required

var gaussPartial = Fn.new { |a0, b0|
    var m = b0.count
    var a = List.filled(m, null)
    var i = 0
    for (ai in a0) {
        var row = ai.toList
        row.add(b0[i])
        a[i] = row
        i = i + 1
    }
    for (k in 0...a.count) {
        var iMax = 0
        var max = -1
        for (i in Stepped.ascend(k...m)) {
            var row = a[i]
            // compute scale factor s = max abs in row
            var s = -1
            for (j in Stepped.ascend(k...m)) {
                var e = row[j].abs
                if (e > s) s = e
            }
            // scale the abs used to pick the pivot
            var abs = row[k].abs / s
            if (abs > max) {
                iMax = i
                max = abs
            }
        }
        if (a[iMax][k] == 0) Fiber.abort("Matrix is singular.")
        a.swap(k, iMax)
        for (i in Stepped.ascend(k + 1...m)) {
            for (j in Stepped.ascend(k + 1..m)) {
                a[i][j] = a[i][j] - a[k][j] * a[i][k] / a[k][k]
            }
            a[i][k] = 0
        }
    }
    var x = List.filled(m, 0)
    for (i in Stepped.descend(m - 1..0)) {
        x[i] = a[i][m]
        for (j in Stepped.ascend(i + 1...m)) {
            x[i] = x[i] - a[i][j] * x[j]
        }
        x[i] = x[i] / a[i][i]
    }
    return x
}

var x = gaussPartial.call(ta, tb)
System.print(x)
var i = 0
for (xi in x) {
    if ((tx[i] - xi).abs > EPSILON) {
        System.print("Out of tolerance.")
        System.print("Expected values are %(tx)")
        return
    }
    i = i + 1
}
