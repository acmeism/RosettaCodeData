import "/complex" for Complex

var quadratic = Fn.new { |a, b, c|
    var d = b*b - 4*a*c
    if (d == 0) {
        // single root
        return [[-b/(2*a)], null]
    }
    if (d > 0) {
        // two real roots
        var sr = d.sqrt
        d = (b < 0) ? sr - b : -sr - b
        return [[d/(2*a), 2*c/d], null]
    }
    // two complex roots
    var den = 1 / (2*a)
    var t1 = Complex.new(-b*den, 0)
    var t2 = Complex.new(0, (-d).sqrt * den)
    return [[], [t1+t2, t1-t2]]
}

var test = Fn.new { |a, b, c|
    System.write("coefficients: %(a), %(b), %(c) -> ")
    var roots = quadratic.call(a, b, c)
    var r = roots[0]
    if (r.count == 1) {
        System.print("one real root: %(r[0])")
    } else if (r.count == 2) {
        System.print("two real roots: %(r[0]) and %(r[1])")
    } else {
        var i = roots[1]
        System.print("two complex roots: %(i[0]) and %(i[1])")
    }
}

var coeffs = [
    [1, -2, 1],
    [1,  0, 1],
    [1, -10, 1],
    [1, -1000, 1],
    [1, -1e9, 1]
]

for (c in coeffs) test.call(c[0], c[1], c[2])
