import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(1049)
System.print("Special primes under 1,050:")
System.print("Prime1 Prime2 Gap")
var lastSpecial = primes[1]
var lastGap = primes[1] - primes[0]
Fmt.print("$6d $6d $3d", primes[0], primes[1], lastGap)
for (p in primes.skip(2)) {
    if ((p - lastSpecial) > lastGap) {
        lastGap = p - lastSpecial
        Fmt.print("$6d $6d $3d", lastSpecial, p, lastGap)
        lastSpecial = p
    }
}
