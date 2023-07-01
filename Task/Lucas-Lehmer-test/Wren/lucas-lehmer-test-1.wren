import "/big" for BigInt
import "/math" for Int
import "io" for Stdout

var start = System.clock
var max = 19
var count = 0
var table = [521, 607, 1279, 2203, 2281, 3217, 4253, 4423]
var p  = 3 // first odd prime
var ix = 0 // index into table for larger primes
var one = BigInt.one
var two = BigInt.two
while (true) {
    var m = (BigInt.two << (p - 1)) - one
    var s = BigInt.four
    for (i in 1..p-2) s = (s.square - two) % m
    if (s.bitLength == 0) {
        count = count + 1
        System.write("M%(p) ")
        Stdout.flush()
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
