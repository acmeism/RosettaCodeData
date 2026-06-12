import "./math" for Int
import "./fmt" for Fmt

var sumDigits = Fn.new { |n|
    var sum = 0
    while (n > 0) {
        sum = sum + (n % 10)
        n = (n/10).floor
    }
    return sum
}

var primes = Int.primeSieve(4999).where { |p| p >= 997 }
var primes25 = []
for (p in primes) {
    if (sumDigits.call(p) == 25) primes25.add(p)
}
System.print("The %(primes25.count) primes under 5,000 whose digits sum to 25 are:")
Fmt.tprint("$,6d", primes25, 6)
