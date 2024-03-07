import "./fmt" for Fmt

var ndigits = Fn.new { |x|
    var n = 0
    while (x > 0) {
        n = n + 1
        x = (x/10).floor
    }
    return n
}

var dtally = Fn.new { |x|
    var t = 0
    while (x > 0) {
        t = t + 2.pow((x%10) * 6)
        x = (x/10).floor
    }
    return t
}

var tens = List.filled(15, 0)

var init = Fn.new  {
    tens[0] = 1
    for (i in 1..14) tens[i] = tens[i-1] * 10
}

var fangs = Fn.new { |x|
    var f = []
    var nd = ndigits.call(x)
    if ((nd&1) == 1) return f
    nd = (nd/2).floor
    var lo = tens[nd-1].max(((x + tens[nd] - 2) / (tens[nd] - 1)).floor)
    var hi = (x/lo).floor.min(x.sqrt.floor)
    var t = dtally.call(x)
    var a = lo
    while (a <= hi) {
        var b = (x/a).floor
        if (a*b == x && ((a%10) > 0 || (b%10) > 0) && t == dtally.call(a) + dtally.call(b)) {
            f.add(a)
        }
        a = a + 1
    }
    return f
}

var showFangs = Fn.new { |x, f|
    Fmt.write("$6d", x)
    if (f.count > 1) System.print()
    for (a in f) Fmt.print(" = $3d x $3d", a, (x/a).floor)
}

init.call()
var x = 1
var n = 0
while (n < 25) {
    var f = fangs.call(x)
    if (f.count > 0) {
        n = n + 1
        Fmt.write("$2d: ", n)
        showFangs.call(x, f)
    }
    x = x + 1
}
System.print()
for (x in [16758243290880, 24959017348650, 14593825548650]) {
    var f = fangs.call(x)
    if (f.count > 0) {
        showFangs.call(x, f)
    } else {
        Fmt.print("$d is not vampiric", x)
    }
}
