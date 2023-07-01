/* home_primes_gmp.wren */

import "./gmp" for Mpz
import "./math" for Int

var list = (2..20).toList
list.add(65)
for (i in list) {
    if (Int.isPrime(i)) {
        System.print("HP%(i) = %(i)")
        continue
    }
    var n = 1
    var j = Mpz.from(i)
    var h = [j.copy()]
    while (true) {
        var k = Mpz.primeFactors(j).reduce("") { |acc, f| acc + f.toString }
        j = Mpz.fromStr(k)
        h.add(j)
        if (j.probPrime(15) > 0) {
            for (l in n...0) System.write("HP%(h[n-l])(%(l)) = ")
            System.print(h[n])
            break
        } else {
            n = n + 1
        }
    }
}
