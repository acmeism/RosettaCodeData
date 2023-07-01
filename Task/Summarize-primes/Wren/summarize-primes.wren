import "/math" for Int
import "/fmt" for Fmt

var primes = Int.primeSieve(999)
var sum = 0
var n = 0
var c = 0
System.print("Summing the first n primes (<1,000) where the sum is itself prime:")
System.print("  n  cumulative sum")
for (p in primes) {
    n = n + 1
    sum = sum + p
    if (Int.isPrime(sum)) {
        c = c + 1
        Fmt.print("$3d   $,6d", n, sum)
    }
}
System.print("\n%(c) such prime sums found")
