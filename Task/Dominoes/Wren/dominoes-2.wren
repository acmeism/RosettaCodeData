import "./big" for BigInt
import "./fmt" for Fmt

var dominoTilingCount = Fn.new { |m, n|
    var prod = 1
    for (j in 1..(m/2).ceil) {
        for (k in 1..(n/2).ceil) {
            var cm = (Num.pi * (j / (m + 1))).cos
            var cn = (Num.pi * (k / (n + 1))).cos
            prod = prod * ((cm*cm + cn*cn) * 4)
        }
    }
    return prod.floor
}

var start  = System.clock
var arrang = dominoTilingCount.call(7, 8)
var perms  = BigInt.factorial(28)
var flips  = 2.pow(28)

Fmt.print("Arrangements ignoring values: $,i", arrang)
Fmt.print("Permutations of 28 dominos: $,i", perms)
Fmt.print("Permuted arrangements ignoring flipping dominos: $,i", perms * arrang)
Fmt.print("Possible flip configurations: $,i", flips)
Fmt.print("Possible permuted arrangements with flips: $,i", perms * flips * arrang)
System.print("\nTook %(System.clock - start) seconds.")
