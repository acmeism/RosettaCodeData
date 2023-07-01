var bc = Fn.new { |p|
    var c = List.filled(p+1, 0)
    var r = 1
    var half = (p/2).floor
    for (i in 0..half) {
        c[i] = r
        c[p-i] = r
        r = (r * (p-i) / (i+1)).floor
    }
    var j = p - 1
    while (j >= 0) {
        c[j] = -c[j]
        j = j - 2
    }
    return c
}

var e = "²³⁴⁵⁶⁷".codePoints.toList

var pp = Fn.new { |c|
    if (c.count == 1) return "%(c[0])"
    var p = c.count - 1
    var s = ""
    if (c[p] != 1) s = "%(c[p])"
    if (p == 0) return s
    for (i in p..1) {
        s = s + "x"
        if (i != 1) s = s + String.fromCodePoint(e[i-2])
        var d = c[i-1]
        s = s + ((d < 0) ? "  - %(-d)" : "  + %(d)")
    }
    return s
}

var aks = Fn.new { |p|
    var c = bc.call(p)
    c[p] = c[p] - 1
    c[0] = c[0] + 1
    for (d in c) {
        if (d%p != 0) return false
    }
    return true
}

for (p in 0..7) System.print("%(p):  %(pp.call(bc.call(p)))")
System.print("\nAll primes under 50:")
for (p in 2..49) if (aks.call(p)) System.write("%(p) ")
System.print()
