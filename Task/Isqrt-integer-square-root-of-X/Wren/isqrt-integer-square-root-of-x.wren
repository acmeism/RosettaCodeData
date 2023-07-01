import "/big" for BigInt
import "/fmt" for Fmt

var isqrt = Fn.new { |x|
    if (!(x is BigInt && x >= BigInt.zero)) {
        Fiber.abort("Argument must be a non-negative big integer.")
    }
    var q = BigInt.one
    while (q <= x) q = q * 4
    var z = x
    var r = BigInt.zero
    while (q > BigInt.one) {
        q = q >> 2
        var t = z - r - q
        r = r >> 1
        if (t >= 0) {
            z = t
            r = r + q
        }
    }
    return r
}

System.print("The integer square roots of integers from 0 to 65 are:")
for (i in 0..65) System.write("%(isqrt.call(BigInt.new(i))) ")
System.print()

System.print("\nThe integer square roots of powers of 7 from 7^1 up to 7^73 are:\n")
System.print("power                                    7 ^ power                                                 integer square root")
System.print("----- --------------------------------------------------------------------------------- -----------------------------------------")
var pow7 = BigInt.new(7)
var bi49 = BigInt.new(49)
var i = 1
while (i <= 73) {
    Fmt.print("$2d $,84s $,41s", i, pow7, isqrt.call(pow7))
    pow7 = pow7 * bi49
    i = i + 2
}
