import "./math" for Int
import "./gmp" for Mpz
import "./fmt" for Fmt

var limit = 16 * 1e6 // more than enough to find first million primes
var primes = Int.primeSieve(limit-1)
primes.insert(0, 1)
System.print("The first ten primorial numbers are:")
var z = Mpz.new()
for (i in 0..9) System.print("%(i): %(z.primorial(primes[i]))")

System.print("\nThe following primorials have the lengths shown:")
for (i in [1e1, 1e2, 1e3, 1e4, 1e5, 1e6]) {
    Fmt.print("$7d:  $d", i, z.primorial(primes[i]).digitsInBase(10))
}
