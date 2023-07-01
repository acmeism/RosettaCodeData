import "/big" for BigInt, BigRat
import "/fmt" for Fmt

var factorial = Fn.new { |n|
    if (n < 2) return BigInt.one
    var fact = BigInt.one
    for (i in 2..n) fact = fact * i
    return fact
}

var almkvistGiullera = Fn.new { |n, print|
    var t1 = factorial.call(6*n) * 32
    var t2 = 532*n*n + 126*n + 9
    var t3 = factorial.call(n).pow(6)*3
    var ip = t1 * t2 / t3
    var pw = 6*n + 3
    var tm = BigRat.new(ip, BigInt.ten.pow(pw))
    if (print) {
        Fmt.print("$d  $44i  $3d  $-35s", n, ip, -pw, tm.toDecimal(33))
    } else {
        return tm
    }
}

System.print("N                               Integer Portion  Pow  Nth Term (33 dp)")
System.print("-" * 89)
for (n in 0..9) {
    almkvistGiullera.call(n, true)
}

var sum  = BigRat.zero
var prev = BigRat.zero
var prec = BigRat.new(BigInt.one, BigInt.ten.pow(70))
var n = 0
while(true) {
    var term = almkvistGiullera.call(n, false)
    sum = sum + term
    if ((sum-prev).abs < prec) break
    prev = sum
    n = n + 1
}
var pi = BigRat.one/sum.sqrt(70)
System.print("\nPi to 70 decimal places is:")
System.print(pi.toDecimal(70))
