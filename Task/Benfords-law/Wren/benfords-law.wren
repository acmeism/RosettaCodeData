import "./fmt" for Fmt

var fib1000 = Fn.new {
    var a = 0
    var b = 1
    var r = List.filled(1000, 0)
    for (i in 0...r.count) {
        var oa = a
        var ob = b
        r[i] = ob
        a = ob
        b = ob + oa
    }
    return r
}

var LN10 = 2.3025850929940457

var log10 = Fn.new { |x| x.log / LN10 }

var show = Fn.new { |c, title|
    var f = List.filled(9, 0)
    for (v in c) {
        var t = "%(v)".bytes[0] - 49
        f[t] = f[t] + 1
    }
    System.print(title)
    System.print("Digit  Observed  Predicted")
    for (i in 0...f.count) {
        var n = f[i]
        var obs = Fmt.f(9, n/c.count, 3)
        var t = log10.call(1/(i + 1) + 1)
        var pred = Fmt.f(8, t, 3)
        System.print("  %(i+1) %(obs)  %(pred)")
    }
}

show.call(fib1000.call(), "First 1000 Fibonacci numbers:")
