import "./fmt" for Fmt
import "./big" for BigInt

class Factorial {
    static iterative(n) {
        if (n < 2) return BigInt.one
        var fact = BigInt.one
        for (i in 2..n.toSmall) fact = fact * i
        return fact
    }

    static recursive(n) {
        if (n < 2) return BigInt.one
        return n * recursive(n-1)
    }
}

var n = BigInt.new(24)
Fmt.print("Factorial(%(n)) iterative -> $,s", Factorial.iterative(n))
Fmt.print("Factorial(%(n)) recursive -> $,s", Factorial.recursive(n))
