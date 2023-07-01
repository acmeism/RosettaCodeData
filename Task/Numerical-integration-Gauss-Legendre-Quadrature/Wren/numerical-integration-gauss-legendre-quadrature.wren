import "/fmt" for Fmt

var N = 5

var lroots = List.filled(N, 0)
var weight = List.filled(N, 0)

var lcoef  = List.filled(N+1, null)
for (i in 0..N) lcoef[i] = List.filled(N + 1, 0)

var legeCoef = Fn.new {
    lcoef[0][0] = lcoef[1][1] = 1
    for (n in 2..N) {
        lcoef[n][0] = -(n-1) * lcoef[n -2][0] / n
        for (i in 1..n) {
            lcoef[n][i] = ((2*n - 1) * lcoef[n-1][i-1] - (n - 1) * lcoef[n-2][i]) / n
        }
    }
}

var legeEval = Fn.new { |n, x| (n..1).reduce(lcoef[n][n]) { |s, i| s*x + lcoef[n][i-1] } }

var legeDiff = Fn.new { |n, x|
    return n * (x * legeEval.call(n, x) - legeEval.call(n-1, x)) / (x*x - 1)
}

var legeRoots = Fn.new {
    var x = 0
    var x1 = 0
    for (i in 1..N) {
        x = (Num.pi * (i - 0.25) / (N + 0.5)).cos
        while (true) {
            x1 = x
            x = x - legeEval.call(N, x) / legeDiff.call(N, x)
            if (x == x1) break
        }
        lroots[i-1] = x
        x1 = legeDiff.call(N, x)
        weight[i-1] = 2 / ((1 - x*x) * x1 * x1)
    }
}

var legeIntegrate = Fn.new { |f, a, b|
    var c1 = (b - a) / 2
    var c2 = (b + a) / 2
    var sum = 0
    for (i in 0...N) sum = sum + weight[i] * f.call(c1*lroots[i] + c2)
    return c1 * sum
}

legeCoef.call()
legeRoots.call()
System.write("Roots: ")
for (i in 0...N) Fmt.write(" $f", lroots[i])
System.write("\nWeight:")
for (i in 0...N) Fmt.write(" $f", weight[i])

var f = Fn.new { |x| x.exp }
var actual = 3.exp - (-3).exp
Fmt.print("\nIntegrating exp(x) over [-3, 3]:\n\t$10.8f,\n" +
    "compared to actual\n\t$10.8f", legeIntegrate.call(f, -3, 3), actual)
