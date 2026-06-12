import "./math" for Int
import "./fmt"  for Fmt

var sgp = []
var p = 2
var count = 0
while (count < 50) {
    if (Int.isPrime(p) && Int.isPrime(2*p+1)) {
        sgp.add(p)
        count = count + 1
    }
    p = (p != 2) ? p + 2 : 3
}
System.print("The first 50 Sophie Germain primes are:")
Fmt.tprint("$,5d", sgp, 10)
