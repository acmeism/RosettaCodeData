import "./math" for Int
import "./fmt" for Fmt

var MOD = 2

var fp = Fn.new { |a, k| Int.modPow(a, k, MOD) }

var berlekampMassey = Fn.new { |a|
    var n = a.count - 1
    var ansCoef = []
    var lst = []
    var w = 0
    var delta = 0
    for (i in 1...n + 1) {
        var tmp = 0
        for (j in 0...ansCoef.count) {
            if (i - 1 - j >= 1) tmp = (tmp + a[i - 1 - j] * ansCoef[j]) % MOD
        }
        var discrepancy = (a[i] - tmp + MOD) % MOD
        if (discrepancy == 0) continue
        if (w == 0) {
            ansCoef = List.filled(i, 0)
            w = i
            delta = discrepancy
            continue
        }
        var now = ansCoef.toList
        var mul = discrepancy * fp.call(delta, MOD - 2) % MOD
        var neededLen = lst.count + i - w
        if (ansCoef.count < neededLen) {
            ansCoef.addAll(List.filled(neededLen - ansCoef.count, 0))
        }
        if (i - w - 1 >= 0) {
            ansCoef[i - w - 1] = (ansCoef[i - w - 1] + mul) % MOD
        }
        for (j in 0...lst.count) {
            var idx = i - w + j
            if (idx < ansCoef.count) {
                var termToSubtract = (mul * lst[j]) % MOD
                ansCoef[idx] = (ansCoef[idx] - termToSubtract + MOD) % MOD
            }
        }
        if (ansCoef.count > now.count) {
            lst = now
            w = i
            delta = discrepancy
        }
    }
    return ansCoef.map { |x| (x + MOD) % MOD }.toList
}

var calculateTerm = Fn.new { |m, coef, h|
    var k = coef.count
    if (m < h.count) return (h[m] + MOD) % MOD
    if (k == 0) return 0
    var pCoeffs = List.filled(k + 1, 0)
    pCoeffs[0] = (MOD - 1) % MOD
    for (i in 0...k) pCoeffs[i + 1] = coef[i]

    var polyMul = Fn.new { |a, b, degreeK, pPoly|
        var res = List.filled(2 * degreeK, 0)
        for (i in 0...degreeK) {
            if (a[i] == 0) continue
            for (j in 0...degreeK) res[i + j] = (res[i + j] + a[i] * b[j]) % MOD
        }
        for (i in (2 * degreeK - 1)...(degreeK - 1)) {
            if (res[i] == 0) continue
            var term = res[i]
            res[i] = 0
            for (j in 0..degreeK) {
                var idx = i - j
                if (idx >= 0) res[idx] = (res[idx] + term * pPoly[j]) % MOD
            }
        }
        return res[0...degreeK]
    }

    var f = List.filled(k, 0)
    var g = List.filled(k, 0)
    f[0] = 1
    if (k == 1) g[0] = pCoeffs[1] else g[1] = 1
    var power = m
    while (power > 0) {
        if (power % 2 == 1) f = polyMul.call(f, g, k, pCoeffs)
        g = polyMul.call(g, g, k, pCoeffs)
        power = power >> 1
    }
    var finalAns = 0
    for (i in 0...k) if (i + 1 < h.count) finalAns = (finalAns + h[i + 1] * f[i]) % MOD
    return (finalAns + MOD) % MOD
}

var solve = Fn.new {
    var hInput = [0, 0, 1, 1, 0, 1, 0]
    var n = hInput.count
    var h = [0] + hInput
    var ansCoef = berlekampMassey.call(h)
    var coeffs = ansCoef.map { |x| (x + MOD) % MOD }.toList
    System.print("Coefficients: %(coeffs) (lowest to highest degree)")
    System.write("Hence connection polynomial: ")
    Fmt.pprint("$d", coeffs[-1..0], "", "x")
    System.print("and linear complexity: %(coeffs.count - 1)")
    /* Uncomment the following 3 lines to calculate and show a term. */
    // var m = 10
    // var result = calculateTerm.call(m, ansCoef, h)
    // System.print((result + MOD) % MOD)
}

solve.call()
