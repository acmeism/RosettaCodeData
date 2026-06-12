import "./math" for Int
import "./fmt" for Fmt

var count = 0
var s
var p = Int.primeSieve(1e7 - 1)
for (i in 1...p.count - 1) {
    if (p[i+1] == p[i] + 2 && Int.isSquare(s = p[i] + p[i+1])) {
        var sq = s.sqrt.round
        Fmt.print("$,9d + $,9d = $,10d = $,5d²", p[i], p[i+1], s, sq)
        count = count + 1
    }
}
System.print("\nFound %(count) twin primes whose sum is a square number.")
