import "./big" for BigInt
import "./fmt" for Fmt

var one = BigInt.one
var two = BigInt.two

var a = Fn.new { |n|
    var p = (BigInt.one << (1 << n)) - one
    var k = 1
    while (true) {
        if (p.isProbablePrime(5)) return k
        p = p - two
        k = k + 2
    }
}

System.print(" n   k")
System.print("----------")
for (n in 1..10) Fmt.print("$2d   $d", n, a.call(n))
