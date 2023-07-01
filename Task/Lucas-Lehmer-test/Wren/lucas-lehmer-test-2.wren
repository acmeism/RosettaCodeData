import "./gmp" for Mpz
import "./math" for Int

var start = System.clock
var max = 28
var count = 0
var table = [521, 607, 1279, 2203, 2281, 3217, 4253, 4423, 9689, 9941, 11213, 19937, 21701, 23209, 44497, 86243, 110503]
var p = 3 // first odd prime
var ix = 0
var one = Mpz.one
var two = Mpz.two
var m = Mpz.new()
var s = Mpz.new()
while (true) {
    m.uiPow(2, p).sub(one)
    s.setUi(4)
    for (i in 1..p-2) s.square.sub(two).rem(m)
    if (s.isZero) {
        count = count + 1
        System.write("M%(p) ")
        if (count == max) {
            System.print()
            break
        }
    }
    // obtain next odd prime or look up in table after 127
    if (p < 127) {
        while (true) {
            p = p + 2
            if (Int.isPrime(p)) break
        }
    } else {
        p = table[ix]
        ix = ix + 1
    }
}
System.print("\nTook %(System.clock - start) seconds.")
