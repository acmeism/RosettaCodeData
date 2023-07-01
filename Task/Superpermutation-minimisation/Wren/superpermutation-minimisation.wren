import "/fmt" for Fmt

var max = 12
var sp = []
var count = List.filled(max, 0)
var pos = 0

var factSum = Fn.new { |n|
    var s = 0
    var x = 0
    var f = 1
    while (x < n) {
        x = x + 1
        f = f * x
        s = s + f
    }
    return s
}

var r // recursive
r = Fn.new { |n|
    if (n == 0) return false
    var c = sp[pos - n]
    count[n] = count[n] - 1
    if (count[n] == 0) {
        count[n] = n
        if (!r.call(n - 1)) return false
    }
    sp[pos] = c
    pos = pos + 1
    return true
}

var superPerm = Fn.new { |n|
    pos = n
    var len = factSum.call(n)
    if (len > 0) sp = List.filled(len, "\0")
    for (i in 0..n) count[i] = i
    if (n > 0) {
        for (i in 1..n) sp[i - 1] = String.fromByte(48 + i)
    }
    while (r.call(n)) {}
}

for (n in 0...max) {
    superPerm.call(n)
    Fmt.print("superPerm($2d) len = $d", n, sp.count)
}
