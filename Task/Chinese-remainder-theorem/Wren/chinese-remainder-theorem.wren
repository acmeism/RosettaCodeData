/* returns x where (a * x) % b == 1 */
var mulInv = Fn.new { |a, b|
    if (b == 1) return 1
    var b0 = b
    var x0 = 0
    var x1 = 1
    while (a > 1) {
        var q = (a/b).floor
        var t = b
        b = a % b
        a = t
        t = x0
        x0 = x1 - q*x0
        x1 = t
    }
    if (x1 < 0) x1 = x1 + b0
    return x1
}

var chineseRemainder = Fn.new { |n, a|
    var prod = n.reduce { |acc, i| acc * i }
    var sum = 0
    for (i in 0...n.count) {
        var p = (prod/n[i]).floor
        sum = sum + a[i]*mulInv.call(p, n[i])*p
    }
    return sum % prod
}

var n = [3, 5, 7]
var a = [2, 3, 2]
System.print(chineseRemainder.call(n, a))
