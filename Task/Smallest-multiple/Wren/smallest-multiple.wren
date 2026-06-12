import "./math" for Int
import "./big" for BigInt
import "./fmt" for Fmt

var lcm = Fn.new { |n|
    var primes = Int.primeSieve(n)
    var lcm = BigInt.one
    for (p in primes) {
        var f = p
        while (f * p <= n) f = f * p
        lcm = lcm * f
    }
    return lcm
}

System.print("The LCMs of the numbers 1 to N inclusive is:")
for (i in [10, 20, 200, 2000]) Fmt.print("$,5d: $,i", i, lcm.call(i))
