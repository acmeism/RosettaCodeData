import "/complex" for Complex
import "/fmt" for Fmt

var ditfft2 // recursive
ditfft2 = Fn.new {|x, y, n, s|
    if (n == 1) {
        y[0] = Complex.new(x[0], 0)
        return
    }
    var hn = (n/2).floor
    ditfft2.call(x, y, hn, 2*s)
    var z = y[hn..-1]
    ditfft2.call(x[s..-1], z, hn, 2*s)
    for (i in hn...y.count) y[i] = z[i-hn]
    for (k in 0...hn) {
        var tf = Complex.fromPolar(1, -2 * Num.pi * k / n) * y[k + hn]
        var t = y[k]
        y[k] = y[k] + tf
        y[k + hn] = t - tf
    }
}

var x = [1, 1, 1, 1, 0, 0, 0, 0]
var y = List.filled(x.count, null)
for (i in 0...y.count) y[i] = Complex.zero
ditfft2.call(x, y, x.count, 1)
for (c in y) Fmt.print("$6.4z", c)
