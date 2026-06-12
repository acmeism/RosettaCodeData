import "./math" for Int
import "./fmt" for Fmt

var c = Int.primeSieve(6003, false)
var numbers = []
System.print("Numbers n < 6000 where: n - 1, n + 3, n + 5 are all primes:")
var n = 4
while (n < 6000) {
    if (!c[n-1] && !c[n+3] && !c[n+5]) numbers.add(n)
    n = n + 2
}
for (n in numbers) Fmt.print("$,6d  => $,6d", n, [n-1, n+3, n+5])
System.print("\nFound %(numbers.count) such numbers.")
