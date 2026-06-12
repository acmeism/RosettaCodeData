import "./math" for Math, Nums
import "./fmt" for Fmt

var welch = Fn.new { |a, b|
    return (Nums.mean(a) - Nums.mean(b)) /
        (Nums.variance(a)/a.count + Nums.variance(b)/b.count).sqrt
}

var dof = Fn.new { |a, b|
    var sva = Nums.variance(a)
    var svb = Nums.variance(b)
    var la = a.count
    var lb = b.count
    var n = sva/la + svb/lb
    return n * n / (sva*sva/(la*la*(la-1)) + svb*svb/(lb*lb*(lb-1)))
}

var simpson0 = Fn.new { |nf, upper, f|
    var dx0 = upper/nf
    var sum = (f.call(0) + f.call(dx0*0.5)*4) * dx0
    var x0 = dx0
    for (i in 1...nf) {
        var x1 = (i + 1) * upper / nf
        var xmid = (x0 + x1) * 0.5
        var dx = x1 - x0
        sum = sum + (f.call(x0)*2 + f.call(xmid)*4) * dx
        x0 = x1
    }
    return (sum + f.call(upper)*dx0) / 6
}

var pValue = Fn.new { |a, b|
    var nu = dof.call(a, b)
    var t = welch.call(a, b)
    var g1 = Math.gamma(nu/2).log
    var g2 = Math.gamma(0.5).log
    var g3 = Math.gamma(nu/2 + 0.5).log
    var f = Fn.new { |r| r.pow(nu/2-1) / (1 - r).sqrt }
    return simpson0.call(2000, nu/(t*t + nu), f) / (g1 + g2 - g3).exp
}

var d1 = [27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6, 23.1, 19.6, 19.0, 21.7, 21.4]
var d2 = [27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2, 21.9, 22.1, 22.9, 20.5, 24.4]
var d3 = [17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8]
var d4 = [21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8, 20.7, 21.7, 21.5, 22.5, 23.6,
    21.5, 22.5, 23.5, 21.5, 21.8]
var d5 = [19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0]
var d6 = [28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7, 23.2, 17.5, 20.6, 18.0, 23.9,
    21.6, 24.3, 20.4, 24.0, 13.2]
var d7 = [30.02, 29.99, 30.11, 29.97, 30.01, 29.99]
var d8 = [29.89, 29.93, 29.72, 29.98, 30.02, 29.98]
var x  = [3.0, 4.0, 1.0, 2.1]
var y  = [490.2, 340.0, 433.9]
Fmt.print("$0.6f", pValue.call(d1, d2))
Fmt.print("$0.6f", pValue.call(d3, d4))
Fmt.print("$0.6f", pValue.call(d5, d6))
Fmt.print("$0.6f", pValue.call(d7, d8))
Fmt.print("$0.6f", pValue.call(x, y))
