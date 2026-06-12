import "./ioutil" for Input
import "./complex" for Complex
import "./iterate" for Stepped
import "./seq" for Lst

var echo = true

// The complexity of the algorithm increases
// with alpha, as does the quality guarantee
// on the lattice basis vectors:
// alpha = aln / ald, 1/4 < alpha < 1
var aln = 80
var ald = 81

// rows and columns
var m1 = 0
var mn = 0
var nx = 0
var m  = 0
var n  = 0

// column indices
var c1 = 0
var c2 = 0

// Gram-Schmidt coefficients
// mu_rs = lambda_rs / d_s
// Br = d_r / d_r-1
var la = []
var d  = {} // use map instead of list to deal with an index of -1

// work matrix
var a = []

// input complex constant, read powers into 'a'
var inpConst = Fn.new { |pr|
    var m2 = m1 + 1
    var q = 0
    var g = Input.text(" a + bi: ").trim()  // unlike FB, requires the 'i' for any imaginary part
    var cmplx = Complex.fromString(g)
    Complex.showAsReal = true
    System.print(cmplx)
    var x = cmplx.real
    var y = cmplx.imag

    // fudge factor 1
    a[0][m1] = 1
    // c ^ 0
    var p = 10.pow(pr)
    a[1][m1] = p

    // compute powers
    for (r in Stepped.ascend(2...m)) {
        var t = p
        p = p * x - q * y
        q = t * y + q * x
        a[r][m1] = p.round
        a[r][m2] = q.round
    }
}

// input A and b
var inpSys = Fn.new {
    var sw = 0
    var g = ""
    for (r in 0...n) {
        g = Input.text(" row A%(r+1) and b%(r+1) ")
        // reject all fractional coefficients
        sw = sw | (Lst.indexOfAny(g.toList, ["/", "."]) + 1)

        // parse row
        var i = 0
        var k = g.count
        for (s in 0..m) {
            // locate next column separator (space or |)
            var j
            for (t in -1..0) {
                j = i
                while (i < k) {
                    if (((" |".indexOf(g[i]) == -1) ? -1 : 0) == t) break
                    i = i + 1
                }
            }
            var e = Num.fromString(g[j...i])
            a[s][m1+r] = e ? e : 0
        }
    }
    if (sw != 0) System.print("illegal input")
    return sw
}

// print row r
var prow = Fn.new { |r, l, p|
    for (s in 0..mn) {
        if (s == m1) System.write(" |")
        System.write(" " * (p[s] - l[r][s] + 1))
        System.write(a[r][s])
    }
}

// print matrix A
var printM = Fn.new { |sw|
    var l = List.filled(m+1, null)
    for (i in 0..m) l[i] = List.filled(mn+1, 0)
    var p = List.filled(mn+1, 0)
    for (s in 0..mn) {
        p[s] = 1
        for (r in 0..m) {
            // store lengths and max. length in column
            // for pretty output
            l[r][s] = a[r][s].toString.count
            if (l[r][s] > p[s]) p[s] = l[r][s]
        }
    }

    if (sw != 0) {
        System.print("P | Hnf")

        // evaluate
        var k = 0
        for (r in 0..m) {
            if (a[r][mn] != 0) {
                k = r
                break
            }
        }
        sw = (a[k][mn] == 1) ? -1 : 0
        for (s in m1...mn) sw = sw & ((a[k][s] == 0) ? -1: 0)
        var g = (sw != 0) ? "  -solution" : "   inconsistent"
        for (s in 0...m) sw = sw & ((a[k][s] == 0) ? -1: 0)
        if (sw != 0) g = "" // trivial

        // Hnf and solution
        for (r in Stepped.descend(m..k)) {
            prow.call(r, l, p)
            System.print((r == k) ? g : "")
        }

        // Null space with lengths squared
        for (r in 0...k) {
            prow.call(r, l, p)
            var q = 0
            for (s in 0...m) q = q + a[r][s] * a[r][s]
            System.print("   (%(q))")
        }
    } else {
        System.print("I | Ab~")
        for (r in 0..m) {
            prow.call(r, l, p)
            System.print()
        }
    }
}

/* HMM algorithm 4 */

// negate rows t
var minus = Fn.new { |t|
    for (s in 0..mn) a[t][s] = -a[t][s]
    for (r in 1..m) {
        for (s in 0...r) {
            if (r == t || s == t) la[r][s] = -la[r][s]
        }
    }
}

// LLL reduce rows k
var reduce = Fn.new { |k, t|
    c1 = nx
    c2 = nx

    // pivot elements Ab~ in rows t and k
    for (s in m1..mn) {
        if (a[t][s] != 0) {
            c1 = s
            break
        }
    }
    for (s in m1..mn) {
        if (a[k][s] != 0) {
            c2 = s
            break
        }
    }

    var q = 0
    if (c1 < nx) {
        if (a[t][c1] < 0) minus.call(t)
        q = (a[k][c1] / a[t][c1]).floor
    } else {
        var lk = la[k][t]
        if (2 * lk.abs > d[t]) {
            // 2|lambda_kt| > d_t
            // not LLL-reduced yet
            q = (lk/d[t]).round
        }
    }

    if (q != 0) {
        var sx = (c1 == nx) ? m : mn

        // reduce row k
        for (s in 0..sx) a[k][s] = a[k][s] - q * a[t][s]
        la[k][t] = la[k][t] - q * d[t]
        for (s in 0...t) la[k][s] = la[k][s] - q * la[t][s]
    }
}

// exchange rows k and k - 1
var swop = Fn.new { |k|
    var t = k - 1
    for (s in 0..mn) {
        var tmp = a[k][s]
        a[k][s] = a[t][s]
        a[t][s] = tmp
    }
    for (s in 0...t) {
        var tmp = la[k][s]
        la[k][s] = la[t][s]
        la[t][s] = tmp
    }

    // update Gram coefficients
    // columns k, k-1 for r > k
    var lk = la[k][t]
    var db = (d[t-1] * d[k] + lk * lk) / d[t]
    for (r in Stepped.ascend(k+1..m)) {
        var lr = la[r][k]
        la[r][k] = (d[k] * la[r][t] - lk * lr) / d[t]
        la[r][t] = (db * lr + lk * la[r][k]) / d[k]
    }
    d[t] = db
}

// main limiting sequence
var main = Fn.new { |sw|
    if (sw != 0) {
        inpConst.call(sw)
    } else if (inpSys.call() != 0) {
        return
    }
    // augment Ab~ with column e_m
    a[m][mn] = 1

    // prefix standard basis
    for (i in 0..m) a[i][i] = 1

    // Gram sum-determinants
    for (i in -1..m) d[i] = 1

    if (echo) printM.call(0)
    var tl = 0
    var k = 1
    while (k <= m) {
        var t = k - 1

        // partial size reduction
        reduce.call(k, t)

        sw = (c1 == nx && c2 == nx) ? -1 : 0
        if (sw != 0) {
            // zero rows k-1, k
            var lk = la[k][t]

            // Lovasz condition
            // Bk >= (alpha - mu_kt^2) * Bt
            var db = d[t-1] * d[k] + lk * lk

            // not satisfied
            sw = (db * ald < d[t] * d[t] * aln) ? -1 : 0
        }
        if (sw != 0 || (c1 <= c2 && c1 < nx)) {
            // test recommends a swap
            swop.call(k)

            // decrease k
            if (k > 1) k = k - 1
        } else {
            // complete size reduction
            for (i in Stepped.descend(t-1..0)) reduce.call(k, i)

            // increase k
            k = k + 1
        }
        tl = tl + 1
    }
    printM.call(-1)
    System.print("loop %(tl)")
}

/* driver, input and output */

var g  = ""
var sw = 0
while (true) {
    System.print()
    sw = 0
    while (true) {
        g = Input.text(" rows ")
        if (g.indexOf("'") >= 0) {
            System.print(g)
        } else {
            break
        }
        sw = sw | (g.indexOf("const") + 1)
    }
    n = Num.fromString(g)
    if (!n || n < 1) break

    g = Input.text(" cols ")
    m = Num.fromString(g)
    if (!m || m < 1) {
        for (i in 1..n) g = Input.text("")
        continue
    }

    // set indices and allocate
    if (sw != 0) {
        sw = n - 1
        n = 2
        m = m + 2
    }
    m1 = m + 1
    mn = m1 + n
    nx = mn + 1
    la = List.filled(m+1, null)
    for (i in 0..m) la[i] = List.filled(m+1, 0)
    for (i in -1..m) d[i] = 0
    a = List.filled(m+1, null)
    for (i in 0..m) a[i] = List.filled(mn+1, 0)
    System.write("\e[2J")   // clear the terminal
    System.write("\e[0;0H") // home the cursor
    main.call(sw)
    System.print()
}
