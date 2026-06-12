var kahanSum = Fn.new { |a|
    var sum = 0
    var c = 0
    for (f in a) {
        var y = f - c
        var t = sum + y
        c = (t - sum) - y
        sum = t
    }
    return sum
}

var epsilon = Fn.new {
    var eps = 1
    while (1 + eps != 1) eps = eps/2
    return eps
}

var a = 1
var b = epsilon.call()
var c = -b

var s = (a + b) + c
var k = kahanSum.call([a, b, c])
var d = k - s
System.print("Epsilon      = %(b)")
System.print("(a + b) + c  = %(s)")
System.print("Kahan sum    = %(k)")
System.print("Delta        = %(d)")
