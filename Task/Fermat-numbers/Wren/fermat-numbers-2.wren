/* fermat_numbers_gmp.wren */

import "./gmp" for Mpz
import "./ecm" for Ecm
import "random" for Random

var fermat = Fn.new { |n| Mpz.two.pow(2.pow(n)) + 1 }

var fns = List.filled(10, null)
System.print("The first 10 Fermat numbers are:")
for (i in 0..9) {
    fns[i] = fermat.call(i)
    System.print("F%(String.fromCodePoint(0x2080+i)) = %(fns[i])")
}

System.print("\nFactors of the first 8 Fermat numbers:")
for (i in 0..8) {
    System.write("F%(String.fromCodePoint(0x2080+i)) = ")
    var factors = (i != 7) ? Mpz.primeFactors(fns[i]) : Ecm.primeFactors(fns[i])
    System.write("%(factors)")
    if (factors.count == 1) {
        System.print(" (prime)")
    } else if (!factors[1].probPrime(15)) {
        System.print(" (second factor is composite)")
    } else {
        System.print()
    }
}

System.print("\nThe first factor of F₉ is %(Mpz.pollardRho(fns[9])).")
