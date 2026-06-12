import "./math" for Int
import "./fmt" for Fmt

var p1 = 3
var p2
var s
var count = 0
while (true) {
    p2 = Int.nextPrime(p1)
    if (p2 > 1e7) break
    if (p2 == p1 + 2 && Int.isSquare(s = p1 + p2)) {
        var sq = s.sqrt.round
        Fmt.print("$,9d + $,9d = $,10d = $,5d²", p1, p2, s, sq)
        count = count + 1
    }
    p1 = p2
}
System.print("\nFound %(count) twin primes whose sum is a square number.")
