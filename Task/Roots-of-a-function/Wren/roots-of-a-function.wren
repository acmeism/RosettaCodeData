import "/fmt" for Fmt

var secant = Fn.new { |f, x0, x1|
    var f0 = 0
    var f1 = f.call(x0)
    for (i in 0...100) {
        f0 = f1
        f1 = f.call(x1)
        if (f1 == 0) return [x1, "exact"]
        if ((x1-x0).abs < 1e-6) return [x1, "approximate"]
        var t = x0
        x0 = x1
        x1 = x1-f1*(x1-t)/(f1-f0)
    }
    return [0, ""]
}

var findRoots = Fn.new { |f, lower, upper, step|
    var x0 = lower
    var x1 = lower + step
    while (x0 < upper) {
        x1 = (x1 < upper) ? x1 : upper
        var res = secant.call(f, x0, x1)
        var r = res[0]
        var status = res[1]
        if (status != "" && r >= x0 && r < x1) {
            Fmt.print(" $6.3f $s", r, status)
        }
        x0 = x1
        x1 = x1 + step
    }
}

var example = Fn.new { |x|  x*x*x - 3*x*x + 2*x }
findRoots.call(example, -0.5, 2.6, 1)
