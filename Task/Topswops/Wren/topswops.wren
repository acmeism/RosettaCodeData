import "/fmt" for Fmt

var maxn = 10
var maxl = 50

var steps = Fn.new { |n|
    var a = List.filled(maxl, null)
    var b = List.filled(maxl, null)
    var x = List.filled(maxl, 0)
    for (i in 0...maxl) {
        a[i] = List.filled(maxn + 1, 0)
        b[i] = List.filled(maxn + 1, 0)
    }
    a[0][0] = 1
    var m = 0
    var l = 0
    while (true) {
        x[l] = x[l] + 1
        var k = x[l]
        var cont = false
        if (k >= n) {
            if (l <= 0) break
            l = l - 1
            cont = true
        } else if (a[l][k] == 0) {
            if (b[l][k+1] != 0) cont = true
        } else if (a[l][k] != k + 1) {
            cont = true
        }
        if (!cont) {
            a[l+1] = a[l].toList
            var j = 1
            while (j <= k) {
                a[l+1][j] = a[l][k-j]
                j = j + 1
            }
            b[l+1] = b[l].toList
            a[l+1][0] = k + 1
            b[l+1][k+1] = 1
            if (l > m - 1) {
                m = l + 1
            }
            l = l + 1
            x[l] = 0
        }
    }
    return m
}

for (i in 1..maxn) Fmt.print("$2d: $d", i, steps.call(i))
