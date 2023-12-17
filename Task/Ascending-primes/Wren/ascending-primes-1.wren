import "./math" for Int
import "./fmt"  for Fmt

var isAscending = Fn.new { |n|
    if (n < 10) return true
    var digits = Int.digits(n)
    for (i in 1...digits.count) {
        if (digits[i] <= digits[i-1]) return false
    }
    return true
}

var higherPrimes = []
var candidates = [
    12345678, 12345679, 12345689, 12345789, 12346789,
    12356789, 12456789, 13456789, 23456789, 123456789
]
for (cand in candidates) if (Int.isPrime(cand)) higherPrimes.add(cand)

var primes = Int.primeSieve(3456789)
var ascPrimes = []
for (p in primes) if (isAscending.call(p)) ascPrimes.add(p)
ascPrimes.addAll(higherPrimes)
System.print("There are %(ascPrimes.count) ascending primes, namely:")
Fmt.tprint("$8d", ascPrimes, 10)
