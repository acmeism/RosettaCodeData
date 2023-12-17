import "./fmt" for Fmt

var newSum // recursive
newSum = Fn.new {
    var ms // also recursive
    ms = Fn.new {
        ms = newSum.call()
        return ms.call()
    }
    var msd = 0
    var d = 0
    return Fn.new {
        if (d < 9) {
            d = d + 1
        } else {
            d = 0
            msd = ms.call()
        }
        return msd + d
    }
}

var newHarshard = Fn.new {
    var  i = 0
    var sum = newSum.call()
    return Fn.new {
        i = i + 1
        while (i%sum.call() != 0) i = i + 1
        return i
    }
}

System.print("Gap    Index of gap   Starting Niven")
System.print("===   =============   ==============")
var h = newHarshard.call()
var pg = 0        // previous highest gap
var pn = h.call() // previous Niven number
var i = 1
var n = h.call()
while (n <= 1e9) {
    var g = n - pn
    if (g > pg) {
        Fmt.print("$3d   $,13d   $,14d", g, i, pn)
        pg = g
    }
    pn = n
    i = i + 1
    n = h.call()
}
