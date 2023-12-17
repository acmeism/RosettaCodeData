import "./math" for Int
import "./big" for BigInt
import "./seq" for Lst
import "./fmt" for Fmt

var primes = Int.primeSieve(379)
var primorial = BigInt.one
var fortunates = []
for (prime in primes) {
    primorial = primorial * prime
    var j = 3
    while (true) {
        if ((primorial + j).isProbablePrime(5)) {
            fortunates.add(j)
            break
        }
        j = j + 2
    }
}
fortunates = Lst.distinct(fortunates).sort()
System.print("After sorting, the first 50 distinct fortunate numbers are:")
Fmt.tprint("$3d", fortunates[0..49], 10)
