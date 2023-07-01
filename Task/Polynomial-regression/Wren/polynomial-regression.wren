import "/math" for Nums
import "/seq" for Lst
import "/fmt" for Fmt

var polynomialRegression = Fn.new { |x, y|
    var xm   = Nums.mean(x)
    var ym   = Nums.mean(y)
    var x2m  = Nums.mean(x.map { |e| e * e })
    var x3m  = Nums.mean(x.map { |e| e * e * e })
    var x4m  = Nums.mean(x.map { |e| e * e * e * e })
    var z    = Lst.zip(x, y)
    var xym  = Nums.mean(z.map { |p| p[0] * p[1] })
    var x2ym = Nums.mean(z.map { |p| p[0] * p[0] * p[1] })

    var sxx   = x2m - xm * xm
    var sxy   = xym - xm * ym
    var sxx2  = x3m - xm * x2m
    var sx2x2 = x4m - x2m * x2m
    var sx2y  = x2ym - x2m * ym

    var b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    var c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    var a = ym - b * xm - c * x2m

    var abc = Fn.new { |xx| a + b * xx + c * xx * xx }

    System.print("y = %(a) + %(b)x + %(c)x^2\n")
    System.print(" Input  Approximation")
    System.print(" x   y     y1")
    for (p in z) Fmt.print("$2d $3d  $5.1f", p[0], p[1], abc.call(p[0]))
}

var x = List.filled(11, 0)
for (i in 1..10) x[i] = i
var y = [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321]
polynomialRegression.call(x, y)
