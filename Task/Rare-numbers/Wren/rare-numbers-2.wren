import "/sort" for Sort
import "/fmt" for Fmt
import "/date" for Date

class Z2 {
    construct new(value, hasValue) {
        _value = value
        _hasValue = hasValue
    }
    value { _value }
    hasValue { _hasValue }
}

var Pow10 = List.filled(16, 0)

var init = Fn.new {
    Pow10[0] = 1
    for (i in 1..15) Pow10[i] = 10 * Pow10[i-1]
}

var acc = 0
var bs = List.filled(100000, false)
var L
var H

var izRev
izRev = Fn.new { |n, i, g|
    if ((i/Pow10[n-1]).floor != g%10) return false
    if (n < 2) return true
    return izRev.call(n-1, i%Pow10[n-1], (g/10).floor)
}

var fG = Fn.new { |n, start, end, reset, step|
    var i = step * start
    var g = step * end
    var e = step * reset
    return Fn.new {
        while (i < g) {
            acc = acc + step
            i = i + step
            return Z2.new(acc, true)
        }
        i = e
        acc = acc - (g - e)
        return n.call()
    }
}

class ZP {
    construct new(n, g) {
        _n = n
        _g = g
    }
    n { _n }
    g { _g }
}

class NLH {
    construct new(e) {
        var even = []
        var odd = []
        var n = e.n
        var g = e.g
        var i = n.call()
        while (i.hasValue) {
            for (p in g) {
                var ng = p[0]
                var gg = p[1]
                if (ng > 0 || i.value > 0) {
                    var w = ng*Pow10[4] + gg + i.value
                    var ws = w.sqrt.floor
                    if (ws*ws == w) {
                        if (w%2 == 0) {
                            even.add(w)
                        } else {
                            odd.add(w)
                        }
                    }
                }
            }
            i = n.call()
        }
        _even = even
        _odd = odd
    }
    even { _even }
    odd  { _odd }
}

var makeL = Fn.new { |n|
    var g = List.filled((n/2).floor - 3, null)
    g[0] = Fn.new { Z2.new(0, false) }
    var i = 1
    while (i < (n/2).floor - 3) {
        var s = -9
        if (i == (n/2).floor - 4) s = -10
        var l = Pow10[n-i-4] - Pow10[i+3]
        acc = acc + l*s
        g[i] = fG.call(g[i-1], s, 9, -9, l)
        i = i + 1
    }
    var g0 = 0
    var g1 = 0
    var g2 = 0
    var g3 = 0
    var l0 = Pow10[n-5]
    var l1 = Pow10[n-6]
    var l2 = Pow10[n-7]
    var l3 = Pow10[n-8]
    var f = Fn.new {
        var w = []
        while (g0 < 7) {
            var nn = g3*l3 + g2*l2 + g1*l1 + g0*l0
            var gg = -1000*g3 - 100*g2 - 10*g1 - g0
            if (g3 < 9) {
                g3 = g3 + 1
            } else {
                g3 = -9
                if (g2 < 9) {
                    g2 = g2 + 1
                } else {
                    g2 = -9
                    if (g1 < 9) {
                        g1 = g1 + 1
                    } else {
                        g1 = -9
                        if (g0 == 1) g0 = 3
                        g0 = g0 + 1
                    }
                }
            }
            if (bs[(Pow10[10]+gg)%10000]) w.add([nn, gg])
        }
        return w
    }
    return ZP.new(g[(n/2).floor-4], f.call())
}

var makeH = Fn.new { |n|
    acc = -(Pow10[(n/2).floor] + Pow10[((n-1)/2).floor])
    var g = List.filled(((n+1)/2).floor - 3, null)
    g[0] = Fn.new { Z2.new(0, false) }
    var i = 1
    while (i < (n/2).floor - 3) {
        var j = 0
        if (i == ((n+1)/2).floor - 3) j = -1
        g[i] = fG.call(g[i-1], j, 18, 0, Pow10[n-i-4]+Pow10[i+3])
        if (n%2 == 1) {
            g[((n+1)/2).floor-4] = fG.call(g[(n/2).floor-4], -1, 9, 0, 2*Pow10[(n/2).floor])
        }
        i = i + 1
    }
    var g0 = 4
    var g1 = 0
    var g2 = 0
    var g3 = 0
    var l0 = Pow10[n-5]
    var l1 = Pow10[n-6]
    var l2 = Pow10[n-7]
    var l3 = Pow10[n-8]
    var f = Fn.new {
        var w = []
        while (g0 < 17) {
            var nn = g3*l3 + g2*l2 + g1*l1 + g0*l0
            var gg = 1000*g3 + 100*g2 + 10*g1 + g0
            if (g3 < 18) {
                g3 = g3 + 1
            } else {
                g3 = 0
                if (g2 < 18) {
                    g2 = g2 + 1
                } else {
                    g2 = 0
                    if (g1 < 18) {
                        g1 = g1 + 1
                    } else {
                        g1 = 0
                        if (g0 == 6 || g0 == 9) g0 = g0 + 3
                        g0 = g0 + 1
                    }
                }
            }
            if (bs[gg%10000]) w.add([nn, gg])
        }
        return w
    }
    return ZP.new(g[((n+1)/2).floor-4], f.call())
}

var rare = Fn.new { |n|
    acc = 0
    for (g in 0...10000) bs[(g*g)%10000] = true
    L = NLH.new(makeL.call(n))
    H = NLH.new(makeH.call(n))
    var rares = []
    for (l in L.even) {
        for (h in H.even) {
            var r = ((h - l)/2).floor
            var z = h - r
            if (izRev.call(n, r, z)) rares.add(z)
        }
    }
    for (l in L.odd) {
        for (h in H.odd) {
            var r = ((h - l)/2).floor
            var z = h - r
            if (izRev.call(n, r, z)) rares.add(z)
        }
    }
    if (rares.count > 0) Sort.quick(rares)
    return rares
}

// Formats time in form hh:mm:ss.fff (i.e. millisecond precision).
var formatTime = Fn.new { |d|
   var ms = (d * 1000).round
   var tm = Date.fromNumber(ms)
   Date.default = Date.isoTime + "|.|ttt"
   return tm.toString
}

var bStart = System.clock  // block time
var tStart = bStart        // total time
init.call()
var nth = 3                // i.e. count of rare numbers < 10 digits
System.print("nth         rare number    digs  block time    total time")
for (nd in 10..15) {
    var rares = rare.call(nd)
    if (rares.count > 0) {
        var i = 0
        for (r in rares) {
            nth = nth + 1
            var t = ""
            if (i < rares.count - 1) t = "\n"
            Fmt.write("$2d  $,21d$s", nth, r, t)
            i = i + 1
        }
    } else {
        Fmt.write("$26s", "")
    }
    var fbTime = formatTime.call(System.clock - bStart)
    var ftTime = formatTime.call(System.clock - tStart)
    Fmt.print("  $2d: $s  $s", nd, fbTime, ftTime)
    bStart = System.clock // restart block timing
}
