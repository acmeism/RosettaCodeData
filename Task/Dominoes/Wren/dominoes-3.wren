import "./gmp" for Mpz, Mpf
import "./fmt" for Fmt

var dominoTilingCount = Fn.new { |m, n|
    var prec = 128
    var prod = Mpf.from(1, prec)
    for (j in 1..(m/2).ceil) {
        for (k in 1..(n/2).ceil) {
            var cm = Mpf.pi(prec).mul(Mpf.from(j / (m + 1))).cos.square
            var cn = Mpf.pi(prec).mul(Mpf.from(k / (n + 1))).cos.square
            prod.mul(cm.add(cn).mul(4))
        }
    }
    return Mpz.from(prod.floor)
}

var start  = System.clock
var arrang = dominoTilingCount.call(7, 8)
var perms  = Mpz.new().factorial(28)
var flips  = 2.pow(28)

Fmt.print("Arrangements ignoring values: $,i", arrang)
Fmt.print("Permutations of 28 dominos: $,i", perms)
Fmt.print("Permuted arrangements ignoring flipping dominos: $,i", perms * arrang)
Fmt.print("Possible flip configurations: $,i", flips)
Fmt.print("Possible permuted arrangements with flips: $,i", perms * flips * arrang)
System.print("\nTook %(System.clock - start) seconds.")
