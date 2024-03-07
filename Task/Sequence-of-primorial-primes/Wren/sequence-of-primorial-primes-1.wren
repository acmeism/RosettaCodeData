import "./big" for BigInt
import "./math" for Int
import "io" for Stdout

var primes = Int.primeSieve(4000) // more than enough for this task
System.print("The indices of the first 15 primorial numbers, p, where p + 1 or p - 1 is prime are:")
var count = 0
var prod = BigInt.two
for (i in 1...primes.count) {
    if ((prod-1).isProbablePrime(5) || (prod+1).isProbablePrime(5)) {
        count = count + 1
        System.write("%(i) ")
        Stdout.flush()
        if (count == 15) break
    }
    prod = prod * primes[i]
}
System.print()
