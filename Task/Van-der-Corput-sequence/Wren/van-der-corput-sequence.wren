var v2 = Fn.new { |n|
    var p = 0.5
    var r = 0
    while (n > 0) {
        if (n%2 == 1) r = r + p
        p = p / 2
        n = (n/2).floor
    }
    return r
}

var newV = Fn.new { |base|
    var invb = 1 / base
    return Fn.new { |n|
        var p = invb
        var r = 0
        while (n > 0) {
            r = r + p*(n%base)
            p = p * invb
            n = (n/base).floor
        }
        return r
    }
}

System.print("Base 2:")
for (i in 0..9) System.print("%(i) -> %(v2.call(i))")

System.print("\nBase 3:")
var v3 = newV.call(3)
for (i in 0..9) System.print("%(i) -> %(v3.call(i))")
