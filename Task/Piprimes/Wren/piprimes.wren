import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(79) // go up to the 22nd
var ix = 0
var n = 1
var count = 0
var pi = []
while (true) {
    if (primes[ix] <= n) {
       count = count + 1
       if (count == 22) break
       ix = ix + 1
    }
    n = n + 1
    pi.add(count)
}
System.print("pi(n), the number of primes <= n, where n >= 1 and pi(n) < 22:")
Fmt.tprint("$2d", pi, 10)
System.print("\nHighest n for this range = %(pi.count).")
