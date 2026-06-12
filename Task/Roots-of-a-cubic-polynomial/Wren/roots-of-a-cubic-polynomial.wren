import "./matrix" for Matrix
import "./math" for Math
import "./complex" for Complex
import "./fmt" for Fmt

class Polynom {
    // assumes factors start from lowest order term
    construct new(factors) {
        _factors = factors.toList
    }

    factors { _factors.toList }

    /(divisor) {
        var curr = canonical().factors
        var right = divisor.canonical().factors
        var result = []
        var base = curr.count - right.count
        while (base >= 0) {
            var res = curr[-1] / right[-1]
            result.add(res)
            curr = curr[0...-1]
            for (i in 0...right.count-1) {
                curr[base + i] = curr[base + i] - res * right[i]
            }
            base = base - 1
        }
        var quot = Polynom.new(result[-1..0])
        var rem = Polynom.new(curr).canonical()
        return [quot, rem]
    }

    canonical() {
        if (_factors[-1] != 0) return this
        var newLen = factors.count
        while (newLen > 0) {
            if (_factors[newLen-1] != 0) return Polynom.new(_factors[0...newLen])
            newLen = newLen - 1
        }
        return Polynom.new(_factors[0..0])
    }
}

// assumes real coefficients, highest to lowest order
var quadratic = Fn.new { |a, b, c|
    var d = b*b - 4*a*c
    if (d == 0) {
        // single real root
        var root = -b/(a*2)
        return [root, root]
    }
    if (d > 0) {
        // two real roots
        var sr = d.sqrt
        d = (b < 0) ? sr - b : -sr - b
        return [d/(2*a), 2*c/d]
    }
    // two complex roots
    var den = 1 / (2*a)
    var t1 = Complex.new(-b*den, 0)
    var t2 = Complex.new(0, (-d).sqrt * den)
    return [t1+t2, t1-t2]
}

// same assumption as quadratic but 'x' can be real or complex.
var evalPoly = Fn.new { |coefs, x|
    var c = coefs.count
    if (c == 1) return coefs[0]
    var sum = coefs[0]
    for (i in 1...c) sum = x * sum + coefs[i]
    return sum
}

var eigenvalues = Fn.new { |m|
    var roots = []
    var errs  = []
    // find the characteristic polynomial
    var cp = List.filled(4, 0)
    cp[0] = 1
    cp[1] = -m.trace
    cp[2] = m.cofactors.trace
    cp[3] = -m.det
    // find first root
    roots.add(Math.rootPoly(cp))
    errs.add(evalPoly.call(cp, roots[0]))
    // divide out to get quadratic
    var num = Polynom.new(cp[-1..0])
    var den = Polynom.new([-roots[0], 1])
    var qdr = (num/den)[0]
    // find second and third roots
    var coefs = qdr.factors[-1..0]
    roots = roots + quadratic.call(coefs[0], coefs[1], coefs[2])
    errs.add(evalPoly.call(cp, roots[1]))
    errs.add(evalPoly.call(cp, roots[2]))
    return [cp, roots, errs]
}

var v = 0.70710678118655
var arrs = [
    [
        [ 1, -1,  0],
        [ 0,  1,  1],
        [ 0,  0,  1]
    ],
    [
        [-2, -4,  2],
        [-2,  1,  2],
        [ 4,  2,  5]
    ],
    [
        [ 1, -1,  0],
        [ 0,  1, -1],
        [ 0,  0,  1]
    ],
    [
        [ 2,  0,  0],
        [ 0, -1,  0],
        [ 0,  0, -1]
    ],
    [
        [ 2,  0,  0],
        [ 0,  3,  4],
        [ 0,  4,  9]
    ],
    [
        [ 1,  0,  0],
        [ 0,  v, -v],
        [ 0,  v,  v]
    ]
]

for (i in 0...arrs.count) {
    var m = Matrix.new(arrs[i])
    System.print("For matrix:")
    if (i < arrs.count-1) Fmt.mprint(m, 2, 0) else Fmt.mprint(m, 17, 14)
    var eigs = eigenvalues.call(m)
    Fmt.print("\nwhose characteristic polynomial is:")
    Fmt.pprint("$n", eigs[0], "", "x")
    Fmt.print("\nIts eigenvalues are: $n", eigs[1])
    Fmt.print("and the corresponding errors are: $n\n", eigs[2])
}
