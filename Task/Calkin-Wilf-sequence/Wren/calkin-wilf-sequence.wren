import "/rat" for Rat
import "/fmt" for Fmt, Conv

var calkinWilf = Fn.new { |n|
    var cw = List.filled(n, null)
    cw[0] = Rat.one
    for (i in 1...n) {
        var t = cw[i-1].floor * 2 - cw[i-1] + 1
        cw[i] = Rat.one / t
    }
    return cw
}

var toContinued = Fn.new { |r|
    var a = r.num
    var b = r.den
    var res = []
    while (true) {
        res.add((a/b).floor)
        var t = a % b
        a = b
        b = t
        if (a == 1) break
    }
    if (res.count%2 == 0) { // ensure always odd
        res[-1] = res[-1] - 1
        res.add(1)
    }
    return res
}

var getTermNumber = Fn.new { |cf|
    var b = ""
    var d = "1"
    for (n in cf) {
        b = (d * n) + b
        d = (d == "1") ? "0" : "1"
    }
    return Conv.atoi(b, 2)
}

var cw = calkinWilf.call(20)
System.print("The first 20 terms of the Calkin-Wilf sequence are:")
Rat.showAsInt = true
for (i in 1..20) Fmt.print("$2d: $s", i, cw[i-1])
System.print()
var r = Rat.new(83116, 51639)
var cf = toContinued.call(r)
var tn = getTermNumber.call(cf)
Fmt.print("$s is the $,r term of the sequence.", r, tn)
