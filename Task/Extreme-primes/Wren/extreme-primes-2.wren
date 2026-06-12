import "./gmp" for Mpz
import "./fmt" for Fmt

var extremes = [2]
var sum = Mpz.two
var count = 1
var p = Mpz.three
while (true) {
    sum.add(p)
    if (sum.probPrime(5) > 0) {
        count = count + 1
        if (count <= 30) {
            extremes.add(sum.toNum)
        }
        if (count == 30) {
            System.print("The first 30 extreme primes are:")
            Fmt.tprint("$,7i ", extremes, 6)
            System.print()
        } else if (count % 1000 == 0) {
            var m = count / 1000
            if (m < 6 || m == 30 || m == 40 || m == 50) {
                Fmt.print("The $,8r extreme prime is: $,18i for p <= $,10i", count, sum, p)
                if (m == 50) return
            }
        }
    }
    p.nextPrime
}
