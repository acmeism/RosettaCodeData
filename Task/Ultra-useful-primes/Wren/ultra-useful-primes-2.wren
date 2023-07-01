import "./gmp" for Mpz
import "./fmt" for Fmt

var one = Mpz.one
var two = Mpz.two

var a = Fn.new { |n|
    var p = Mpz.one.lsh(1 << n).sub(one)
    var k = 1
    while (true) {
        if (p.probPrime(15) > 0) return k
        p.sub(two)
        k = k + 2
    }
}

System.print(" n   k")
System.print("----------")
for (n in 1..14) Fmt.print("$2d   $d", n, a.call(n))
