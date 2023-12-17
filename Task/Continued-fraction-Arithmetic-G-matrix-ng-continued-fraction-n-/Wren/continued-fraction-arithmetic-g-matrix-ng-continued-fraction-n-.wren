import "./dynamic" for Tuple

var CFData = Tuple.create("Tuple", ["str", "ng", "r", "gen"])

var r2cf = Fn.new { |frac|
    var num = frac[0]
    var den = frac[1]
    while (den.abs != 0) {
        var div = (num/den).truncate
        var rem = num % den
        num = den
        den = rem
        Fiber.yield(div)
    }
}

var d2cf = Fn.new { |d|
    while (true) {
        var div = d.floor
        var rem = d - div
        Fiber.yield(div)
        if (rem == 0) break
        d = 1 / rem
    }
}

var root2 = Fn.new {
    Fiber.yield(1)
    while (true) Fiber.yield(2)
}

var recipRoot2 = Fn.new {
    Fiber.yield(0)
    Fiber.yield(1)
    while (true) Fiber.yield(2)
}

class NG {
    construct new(a1, a, b1, b) {
        _a1 = a1
        _a  = a
        _b1 = b1
        _b  = b
    }

    ingress(n) {
        var t = _a
        _a = _a1
        _a1 = t + _a1 * n
        t = _b
        _b = _b1
        _b1 = t + _b1 * n
    }

    egress() {
        var n = (_a/_b).truncate
        var t = _a
        _a = _b
        _b = t - _b * n
        t = _a1
        _a1 = _b1
        _b1 = t - _b1 * n
        return n
    }

    needTerm { (_b == 0 || _b1 == 0) || ((_a / _b) != (_a1 / _b1)) }

    egressDone {
        if (needTerm) {
            _a = _a1
            _b = _b1
        }
        return egress()
    }

    done { _b == 0 &&  _b1 == 0 }
}

var data = [
    CFData.new("[1;5,2] + 1/2        ", [2, 1, 0, 2], [13, 11], r2cf),
    CFData.new("[3;7] + 1/2          ", [2, 1, 0, 2], [22,  7], r2cf),
    CFData.new("[3;7] divided by 4   ", [1, 0, 0, 4], [22,  7], r2cf),
    CFData.new("sqrt(2)              ", [0, 1, 1, 0], [ 0,  0], recipRoot2),
    CFData.new("1 / sqrt(2)          ", [0, 1, 1, 0], [ 0,  0], root2),
    CFData.new("(1 + sqrt(2)) / 2    ", [1, 1, 0, 2], [ 0,  0], root2),
    CFData.new("(1 + 1 / sqrt(2)) / 2", [1, 1, 0, 2], [ 0,  0], recipRoot2)
]

System.print("Produced by NG class:")
for (cfd in data) {
    System.write("%(cfd.str) -> ")
    var a1 = cfd.ng[0]
    var a  = cfd.ng[1]
    var b1 = cfd.ng[2]
    var b  = cfd.ng[3]
    var op = NG.new(a1, a, b1, b)
    var seq = []
    var i = 0
    var fib = Fiber.new(cfd.gen)
    while (i < 20) {
        var j = fib.call(cfd.r)
        if (j) seq.add(j) else break
        i = i + 1
    }
    for (n in seq) {
        if (!op.needTerm) System.write(" %(op.egress()) ")
        op.ingress(n)
    }
    while (true) {
        System.write(" %(op.egressDone) ")
        if (op.done) break
    }
    System.print()
}

System.print("\nProduced by direct calculation:")
var data2 = [
    ["(1 + sqrt(2)) / 2    ", (1 + 2.sqrt) / 2],
    ["(1 + 1 / sqrt(2)) / 2", (1 + 1 / 2.sqrt) / 2]
]
for (p in data2) {
    var seq = []
    var fib = Fiber.new(d2cf)
    var i = 0
    while (i < 20) {
        var j = fib.call(p[1])
        if (j) seq.add(j) else break
        i = i + 1
    }
    System.print("%(p[0]) ->  %(seq.join("  "))")
}
