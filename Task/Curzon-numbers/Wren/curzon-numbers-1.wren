/* Curzon_numbers.wren */

import "./gmp" for Mpz
import "./fmt" for Fmt

for (k in [2, 4, 6, 8, 10]) {
    System.print("The first 50 Curzon numbers using a base of %(k):")
    var count = 0
    var n = 1
    var pow = Mpz.from(k)
    var curzon50 = []
    while (true) {
        var z = pow + Mpz.one
        var d = k*n + 1
        if (z.isDivisibleUi(d)) {
            if (count < 50) curzon50.add(n)
            count = count + 1
            if (count == 50) {
                Fmt.tprint("$4d", curzon50, 10)
                System.write("\nOne thousandth: ")
            }
            if (count == 1000) {
                Fmt.print("$,d", n)
                break
            }
        }
        n = n + 1
        pow.mul(k)
    }
    System.print()
}
