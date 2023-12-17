/* Deceptive_numbers.wren */

import "./gmp" for Mpz
import "./math" for Int

var count = 0
var limit = 25
var n = 17
var repunit = Mpz.from(1111111111111111)
var deceptive = []
while (count < limit) {
    if (!Int.isPrime(n) && n % 3 != 0 && n % 5 != 0) {
        if (repunit.isDivisibleUi(n)) {
            deceptive.add(n)
            count = count + 1
        }
    }
    n = n + 2
    repunit.mul(100).add(11)
}
System.print("The first %(limit) deceptive numbers are:")
System.print(deceptive)
