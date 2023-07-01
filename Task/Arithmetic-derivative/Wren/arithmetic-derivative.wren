import "./big" for BigInt
import "./fmt" for Fmt

var D = Fn.new { |n|
    if (n < 0) return -D.call(-n)
    if (n < 2) return BigInt.zero
    var f = BigInt.primeFactors(n)
    var c = f.count
    if (c == 1) return BigInt.one
    if (c == 2) return f[0] + f[1]
    var d = n / f[0]
    return D.call(d) * f[0] + d
}

var ad = List.filled(200, 0)
for (n in -99..100) ad[n+99] = D.call(BigInt.new(n))
Fmt.tprint("$4i", ad, 10)
System.print()
for (m in 1..20) {
    Fmt.print("D(10^$-2d) / 7 = $i", m, D.call(BigInt.ten.pow(m))/7)
}
