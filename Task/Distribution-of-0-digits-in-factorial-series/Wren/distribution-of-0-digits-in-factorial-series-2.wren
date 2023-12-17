import "./fmt" for Fmt

var rfs = [1]  // reverse factorial(1) in base 1000

var init = Fn.new { |zc|
    for (x in 1..9) {
        zc[x-1] = 2         // 00x
        zc[10*x - 1] = 2    // 0x0
        zc[100*x - 1] = 2   // x00
        var y = 10
        while (y <= 90) {
            zc[y + x - 1] = 1       // 0yx
            zc[10*y + x - 1] = 1    // y0x
            zc[10*(y + x) - 1] = 1  // yx0
            y = y + 10
        }
    }
}

var zc = List.filled(999, 0)
init.call(zc)
var total = 0
var trail = 1
var first = 0
var firstRatio = 0
System.print("The mean proportion of zero digits in factorials up to the following are:")
for (f in 2..50000) {
    var carry = 0
    var d999 = 0
    var zeros = (trail-1) * 3
    var j = trail
    var l = rfs.count
    while (j <= l || carry != 0) {
        if (j <= l) carry = rfs[j-1]*f + carry
        d999 = carry % 1000
        if (j <= l) {
            rfs[j-1] = d999
        } else {
            rfs.add(d999)
        }
        zeros = zeros + ((d999 == 0) ? 3 : zc[d999-1])
        carry = (carry/1000).floor
        j = j + 1
    }
    while (rfs[trail-1] == 0) trail = trail + 1
    // d999 = quick correction for length and zeros
    d999 = rfs[-1]
    d999 = (d999 < 100) ? ((d999 < 10) ? 2 : 1) : 0
    zeros = zeros - d999
    var digits = rfs.count * 3 - d999
    total = total + zeros/digits
    var ratio =  total / f
    if (ratio >= 0.16) {
        first = 0
        firstRatio = 0
    } else if (first == 0) {
        first = f
        firstRatio = ratio
    }
    if (f == 100 || f == 1000 || f == 10000) {
        Fmt.print("$,6d = $12.10f", f, ratio)
    }
}
Fmt.write("$,6d = $12.10f", first, firstRatio)
System.print(" (stays below 0.16 after this)")
Fmt.print("$,6d = $12.10f", 50000, total/50000)
