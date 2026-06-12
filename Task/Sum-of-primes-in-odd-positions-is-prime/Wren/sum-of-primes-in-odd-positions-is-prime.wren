import "./math" for Int
import "./iterate" for Indexed
import "./fmt" for Fmt

var primes = Int.primeSieve(999)
var sum = 0
System.print(" i   p[i]  Σp[i]")
System.print("----------------")
for (se in Indexed.new(primes, 2)) {
    sum = sum + se.value
    if (Int.isPrime(sum)) Fmt.print("$3d  $3d  $,6d", se.index + 1, se.value, sum)
}
