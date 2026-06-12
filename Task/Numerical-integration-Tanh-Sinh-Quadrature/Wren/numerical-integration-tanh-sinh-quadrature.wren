import "./math" for Math
import "./fmt" for Fmt

var tanhSinh = Fn.new { |func, lower, upper, steps, acc|
    var h = 0.1
    var h0 = (upper - lower) / 2
    var h1 = (lower + upper) / 2
    var rr = 0
    for (k in 1..steps) {
        var ro = rr
        var n = (1 << k) - 1
        var ss = 0
        for (i in -n .. n) {
            var t = i * h
            var sh = Math.sinh(t)
            var ch = Math.cosh(t)
            var th = Math.tanh(sh * Num.pi / 2)
            var dx = (ch * Num.pi / 2) / (Math.cosh(sh * Num.pi / 2).pow(2))
            var xi = h1 +  h0 * th
            var wt = h * dx
            ss = ss + func.call(xi) * wt
        }
        rr = h0 * ss
        if ((rr - ro).abs < acc) break
    }
    return rr
}

var res = tanhSinh.call(Fn.new { |x| x.sin }, 0, 1, 5, 1e-8)
Fmt.print("$0.8f", res)
res = tanhSinh.call(Fn.new { |x| x.exp }, -3, 3, 5, 1e-8)
Fmt.print("$0.8f", res)
