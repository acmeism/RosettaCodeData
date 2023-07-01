import "/complex" for Complex
import "/fmt" for Fmt

var roots = Fn.new { |n|
    var r = List.filled(n, null)
    for (i in 0...n) r[i] = Complex.fromPolar(1, 2 * Num.pi * i / n)
    return r
}

for (n in 2..5) {
    Fmt.print("$d roots of 1:", n)
    for (r in roots.call(n)) Fmt.print("  $ 0.14z", r)
}
