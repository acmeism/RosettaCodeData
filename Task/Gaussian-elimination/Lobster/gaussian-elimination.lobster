import std

// test case from Go version at http://rosettacode.org/wiki/Gaussian_elimination
//
let ta = [[1.00, 0.00, 0.00, 0.00, 0.00, 0.00],
          [1.00, 0.63, 0.39, 0.25, 0.16, 0.10],
          [1.00, 1.26, 1.58, 1.98, 2.49, 3.13],
          [1.00, 1.88, 3.55, 6.70, 12.62, 23.80],
          [1.00, 2.51, 6.32, 15.88, 39.90, 100.28],
          [1.00, 3.14, 9.87, 31.01, 97.41, 306.02]]

let tb = [-0.01, 0.61, 0.91, 0.99, 0.60, 0.02]

let tx = [-0.01, 1.602790394502114, -1.6132030599055613,
            1.2454941213714368, -0.4909897195846576, 0.065760696175232]

// result from above test case turns out to be correct to this tolerance.
let ε = 1.0e-14

def GaussPartial(a0, b0) -> [float], string:
    // make augmented matrix
    let m = length(b0)
    let a = map(m): []
    for(a0) ai, i:
        //let ai = a0[i]
        a[i] = map(m+1) j: if j < m: ai[j] else: b0[i]
    // WP algorithm from Gaussian elimination page produces row-eschelon form
    var i = 0
    var j = 0
    for(a0) ak, k:
        // Find pivot for column k:
        var iMax = 0
        var kmax = -1.0
        i = k
        while i < m:
            let row = a[i]
            // compute scale factor s = max abs in row
            var s = -1.0
            j = k
            while j < m:
                s = max(s, abs(row[j]))
                j += 1
            // scale the abs used to pick the pivot
            let kabs = abs(row[k]) / s
            if  kabs > kmax:
                iMax = i
                kmax = kabs
            i += 1
        if a[iMax][k] == 0:
            return [], "singular"
        // swap rows(k, i_max)
        let row = a[k]
        a[k] = a[iMax]
        a[iMax] = row
        // Do for all rows below pivot:
        i = k + 1
        while i < m:
            // Do for all remaining elements in current row:
            j = k + 1
            while j <= m:
                a[i][j] -= a[k][j] * (a[i][k] / a[k][k])
                j += 1
            // Fill lower triangular matrix with zeros:
            a[i][k] = 0
            i += 1
    // end of WP algorithm; now back substitute to get result
    let x = map(m): 0.0
    i = m - 1
    while i >= 0:
        x[i] = a[i][m]
        j = i + 1
        while j < m:
            x[i] -= a[i][j] * x[j]
            j += 1
        x[i] /= a[i][i]
        i -= 1
    return x, ""

def test():
    let x, err = GaussPartial(ta, tb)
    if err != "":
        print("Error: " + err)
        return
    print(x)
    for(x) xi, i:
        if abs(tx[i]-xi) > ε:
            print("out of tolerance, expected: " + tx[i] + " got: " + xi)

test()
