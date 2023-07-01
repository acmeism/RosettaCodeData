import "/fmt" for Fmt

var N = 32
var N2 = N * (N - 1) / 2
var STEP = 0.05

var xval = List.filled(N, 0.0)
var tsin = List.filled(N, 0.0)
var tcos = List.filled(N, 0.0)
var ttan = List.filled(N, 0.0)
var rsin = List.filled(N2, 0/0)
var rcos = List.filled(N2, 0/0)
var rtan = List.filled(N2, 0/0)

var rho
rho = Fn.new { |x, y, r, i, n|
    if (n < 0) return 0
    if (n == 0) return y[i]
    var idx = (N - 1 - n) * (N - n) / 2 + i
    if (r[idx].isNan) {
        r[idx] = (x[i] - x[i + n]) /
                 (rho.call(x, y, r, i, n - 1) - rho.call(x, y, r, i + 1, n - 1)) +
                  rho.call(x, y, r, i + 1, n - 2)
    }
    return r[idx]
}

var thiele
thiele = Fn.new { |x, y, r, xin, n|
    if (n > N - 1) return 1
    return rho.call(x, y, r, 0, n) - rho.call(x, y, r, 0, n -2) +
           (xin - x[n]) / thiele.call(x, y, r, xin, n + 1)
}

for (i in 0...N) {
    xval[i] = i * STEP
    tsin[i] = xval[i].sin
    tcos[i] = xval[i].cos
    ttan[i] = tsin[i] / tcos[i]
}
Fmt.print("$16.14f", 6 * thiele.call(tsin, xval, rsin, 0.5, 0))
Fmt.print("$16.14f", 3 * thiele.call(tcos, xval, rcos, 0.5, 0))
Fmt.print("$16.14f", 4 * thiele.call(ttan, xval, rtan, 1.0, 0))
