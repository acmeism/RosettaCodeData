import "./big" for BigInt
import "./fmt" for Fmt

var mul = Fn.new { |m1, m2|
    var rows1 = m1.count
    var cols1 = m1[0].count
    var rows2 = m2.count
    var cols2 = m2[0].count
    if (cols1 != rows2) Fiber.abort("Matrices cannot be multiplied.")
    var result = List.filled(rows1, null)
    for (i in 0...rows1) {
        result[i] = List.filled(cols2, null)
        for (j in 0...cols2) {
            result[i][j] = BigInt.zero
            for (k in 0...rows2) {
                var temp = m1[i][k] * m2[k][j]
                result[i][j] = result[i][j] + temp
            }
        }
    }
    return result
}

var identityMatrix = Fn.new { |n|
    if (n < 1) Fiber.abort("Size of identity matrix can't be less than 1")
    var ident = List.filled(n, 0)
    for (i in 0...n) {
        ident[i] = List.filled(n, null)
        for(j in 0...n) ident[i][j] = (i != j) ? BigInt.zero : BigInt.one
    }
    return ident
}

var pow = Fn.new { |m, n|
    var le = m.count
    if (le != m[0].count) Fiber.abort("Not a square matrix")
    if (n < 0) Fiber.abort("Negative exponents not supported")
    if (n == 0) return identityMatrix.call(le)
    if (n == 1) return m
    var pow = identityMatrix.call(le)
    var base = m
    var e = n
    while (e > 0) {
        var temp = e & BigInt.one
        if (temp == BigInt.one) pow = mul.call(pow, base)
        e = e >> 1
        base = mul.call(base, base)
    }
    return pow
}

var fibonacci = Fn.new { |n|
    if (n == 0) return BigInt.zero
    var m = [[BigInt.one, BigInt.one], [BigInt.one, BigInt.zero]]
    m = pow.call(m, n - 1)
    return m[0][0]
}

var n = BigInt.zero
var i = 10
while (i <= 1e6) {
    n = BigInt.new(i)
    var s = fibonacci.call(n).toString
    Fmt.print("The digits of the $,sth Fibonacci number ($,s) are:", i, s.count)
    if (s.count > 20) {
        Fmt.print("  First 20 : $s", s[0...20])
        if (s.count < 40) {
            Fmt.print("  Final $-2d : $s", s.count-20, s[20..-1])
        } else {
            Fmt.print("  Final 20 : $s", s[s.count-20..-1])
        }
    } else {
        Fmt.print("  All $-2d   : $s", s.count, s)
    }
    System.print()
    i = i * 10
}
n = BigInt.one << 16
var s = fibonacci.call(n).toString
Fmt.print("The digits of the 2^16th Fibonacci number ($,s) are:", s.count)
Fmt.print("  First 20 : $s", s[0...20])
Fmt.print("  Final 20 : $s", s[s.count-20..-1])
