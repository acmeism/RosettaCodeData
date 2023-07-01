import "/fmt" for Conv, Fmt

var zigzag = Fn.new { |n|
    var r = List.filled(n*n, 0)
    var i = 0
    var n2 = n * 2
    for (d in 1..n2) {
        var x = d - n
        if (x < 0) x = 0
        var y = d - 1
        if (y > n - 1) y = n - 1
        var j = n2 - d
        if (j > d) j = d
        for (k in 0...j) {
            if (d&1 == 0) {
                r[(x+k)*n+y-k] = i
            } else {
                r[(y-k)*n+x+k] = i
            }
            i = i + 1
        }
    }
    return r
}

var n = 5
var w = Conv.itoa(n*n - 1).count
var i = 0
for (e in zigzag.call(n)) {
    Fmt.write("$*d ", w, e)
    if (i%n == n - 1) System.print()
    i = i + 1
}
