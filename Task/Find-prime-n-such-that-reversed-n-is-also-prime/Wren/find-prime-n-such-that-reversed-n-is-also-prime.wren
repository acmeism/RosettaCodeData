import "./math" for Int
import "./fmt" for Fmt

var reversed = Fn.new { |n|
    var rev = 0
    while (n > 0) {
        rev = rev * 10 + n % 10
        n = (n/10).floor
    }
    return rev
}

var primes = Int.primeSieve(499)
var reversedPrimes = []
for (p in primes) {
    if (Int.isPrime(reversed.call(p))) reversedPrimes.add(p)
}
System.print("Primes under 500 which are also primes when the digits are reversed:")
Fmt.tprint("$3d", reversedPrimes, 17)
System.print("\n%(reversedPrimes.count) such primes found.")
