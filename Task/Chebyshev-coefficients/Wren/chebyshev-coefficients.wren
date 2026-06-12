import "./fmt" for Fmt

var mapRange = Fn.new { |x, min, max, minTo, maxTo| (x - min)/(max - min)*(maxTo - minTo) + minTo }

var chebCoeffs = Fn.new { |func, n, min, max|
    var coeffs = List.filled(n, 0)
    for (i in 0...n) {
        var f = func.call(mapRange.call((Num.pi * (i + 0.5) / n).cos, -1, 1, min, max)) * 2 / n
        for (j in 0...n) coeffs[j] = coeffs[j] + f * (Num.pi * j * (i + 0.5) / n).cos
    }
    return coeffs
}

var chebApprox = Fn.new { |x, n, min, max, coeffs|
    if (n < 2 || coeffs.count < 2) Fiber.abort("'n' can't be less than 2.")
    var a = 1
    var b = mapRange.call(x, min, max, -1, 1)
    var res = coeffs[0]/2 + coeffs[1]*b
    var xx = 2 * b
    var i = 2
    while (i < n) {
        var c = xx*b - a
        res = res + coeffs[i]*c
        a = b
        b = c
        i = i + 1
    }
    return res
}

var n = 10
var min = 0
var max = 1
var coeffs = chebCoeffs.call(Fn.new { |x| x.cos }, n, min, max)
System.print("Coefficients:")
for (coeff in coeffs) Fmt.print("$0s$1.15f", (coeff >= 0) ? " " : "", coeff)
System.print("\nApproximations:\n  x      func(x)    approx       diff")
for (i in 0..20) {
    var x = mapRange.call(i, 0, 20, min, max)
    var f = x.cos
    var approx = chebApprox.call(x, n, min, max, coeffs)
    var diff = approx - f
    var diffStr = diff.toString
    var e = diffStr[-4..-1]
    diffStr = diffStr[0..-5]
    diffStr = (diff >= 0) ? " " + diffStr[0..3] : diffStr[0..4]
    Fmt.print("$1.3f  $1.8f $1.8f  $s", x, f, approx, diffStr + e)
}
