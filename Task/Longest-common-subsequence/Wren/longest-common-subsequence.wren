var lcs // recursive
lcs = Fn.new { |x, y|
    if (x.count == 0 || y.count == 0) return ""
    var x1 = x[0...-1]
    var y1 = y[0...-1]
    if (x[-1] == y[-1]) return lcs.call(x1, y1) + x[-1]
    var x2 = lcs.call(x, y1)
    var y2 = lcs.call(x1, y)
    return (x2.count > y2.count) ? x2 : y2
}

var x = "thisisatest"
var y = "testing123testing"
System.print(lcs.call(x, y))
