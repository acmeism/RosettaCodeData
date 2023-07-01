import "/fmt" for Fmt

class Num2 {
    construct new(n) { _n = n }

    n { _n}

    ^(exp) {
        if (exp is Num2) exp = exp.n
        return Num2.new(_n.pow(exp))
    }

    - { Num2.new(-_n) }

    toString { _n.toString }
}

var ops = ["-x^p", "-(x)^p", "(-x)^p", "-(x^p)"]
for (x in [Num2.new(-5), Num2.new(5)]) {
    for (p in [Num2.new(2), Num2.new(3)]) {
        Fmt.write("x = $2s p = $s | ", x, p)
        Fmt.write("$s = $4s | ", ops[0], -x^p)
        Fmt.write("$s = $4s | ", ops[1], -(x)^p)
        Fmt.write("$s = $4s | ", ops[2], (-x)^p)
        Fmt.print("$s = $4s",    ops[3], -(x^p))
    }
}
