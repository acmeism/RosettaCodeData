import "./psieve" for Primes
import "./fmt" for Fmt

var it = Primes.iter()
var n = 1
var count = 1
var prime
var target = 36
while (true) {
    if (n % 2 == 1) {
        prime = it.next
        n = n + prime
    } else {
        n = n / 2
    }
    count = count + 1
    if (n == target) {
        Fmt.print("$,r member is: $d and highest prime needed: $,d", count, target, prime)
        return
    }
}
