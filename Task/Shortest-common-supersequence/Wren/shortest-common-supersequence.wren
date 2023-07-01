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

var scs = Fn.new { |u, v|
    var lcs = lcs.call(u, v)
    var ui = 0
    var vi = 0
    var sb = ""
    for (i in 0...lcs.count) {
        while (ui < u.count && u[ui] != lcs[i]) {
            sb = sb + u[ui]
            ui = ui + 1
        }
        while (vi < v.count && v[vi] != lcs[i]) {
            sb = sb + v[vi]
            vi = vi + 1
        }
        sb = sb + lcs[i]
        ui = ui + 1
        vi = vi + 1
    }
    if (ui < u.count) sb = sb + u[ui..-1]
    if (vi < v.count) sb = sb + v[vi..-1]
    return sb
}

var u = "abcbdab"
var v = "bdcaba"
System.print(scs.call(u, v))
