import "./fmt" for Fmt

var MAXITER = 151

var minkowski // predeclare as recursive
minkowski = Fn.new { |x|
    if (x > 1 || x < 0) return x.floor + minkowski.call(x - x.floor)
    var p = x.floor
    var q = 1
    var r = p + 1
    var s = 1
    var d = 1
    var y = p
    while (true) {
        d = d / 2
        if (y + d == y) break
        var m = p + r
        if (m < 0 || p < 0 ) break
        var n = q + s
        if (n < 0) break
        if (x < m/n) {
            r = m
            s = n
        } else {
            y = y + d
            p = m
            q  = n
        }
    }
    return y + d
}

var minkowskiInv
minkowskiInv = Fn.new { |x|
    if (x > 1 || x < 0) return x.floor + minkowskiInv.call(x - x.floor)
    if (x == 1 || x == 0) return x
    var contFrac = [0]
    var curr = 0
    var count = 1
    var i = 0
    while (true) {
        x = x * 2
        if (curr == 0) {
            if (x < 1) {
                count = count + 1
            } else {
                i = i + 1
                var t = contFrac
                contFrac = List.filled(i + 1, 0)
                for (j in 0...t.count) contFrac[j] = t[j]
                contFrac[i-1] = count
                count = 1
                curr = 1
                x = x - 1
            }
        } else {
            if (x > 1) {
                count = count + 1
                x = x - 1
            } else {
                i = i + 1
                var t = contFrac
                contFrac = List.filled(i + 1, 0)
                for (j in 0...t.count) contFrac[j] = t[j]
                contFrac[i-1] = count
                count = 1
                curr = 0
            }
        }
        if (x == x.floor) {
            contFrac[i] = count
            break
        }
        if (i == MAXITER) break
    }
    var ret = 1/contFrac[i]
    for (j in i-1..0) ret = contFrac[j] + 1/ret
    return 1/ret
}

Fmt.print("$17.16f $17.14f", minkowski.call(0.5 * (1 + 5.sqrt)), 5/3)
Fmt.print("$17.14f $17.14f", minkowskiInv.call(-5/9), (13.sqrt - 7)/6)
Fmt.print("$17.14f $17.14f", minkowski.call(minkowskiInv.call(0.718281828)),
                             minkowskiInv.call(minkowski.call(0.1213141516171819)))
