import "./math" for Int
import "./fmt" for Fmt

var extremes = [2]
var sum = 2
var p = 3
var count = 1
while (true) {
    sum = sum + p
    if (Int.isPrime(sum)) {
        count = count + 1
        if (count <= 30) {
            extremes.add(sum)
        }
        if (count == 30) {
            System.print("The first 30 extreme primes are:")
            Fmt.tprint("$,7d ", extremes, 6)
            System.print()
        } else if (count % 1000 == 0) {
            Fmt.print("The $,r extreme prime is: $,14d for p <= $,9d", count, sum, p)
            if (count == 5000) return
        }
    }
    p = Int.nextPrime(p)
}
