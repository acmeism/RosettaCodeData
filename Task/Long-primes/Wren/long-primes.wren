import "./fmt" for Fmt
import "./math" for Int

// finds the period of the reciprocal of n
var findPeriod = Fn.new { |n|
    var r = 1
    for (i in 1..n+1) r = (10*r) % n
    var rr = r
    var period = 0
    var ok = true
    while (ok) {
        r = (10*r) % n
        period = period + 1
        ok = (r != rr)
    }
    return period
}

var primes = Int.primeSieve(64000).skip(1)
var longPrimes = []
for (prime in primes) {
    if (findPeriod.call(prime) == prime - 1) longPrimes.add(prime)
}
var numbers = [500, 1000, 2000, 4000, 8000, 16000, 32000, 64000]
var index = 0
var count = 0
var totals = List.filled(numbers.count, 0)
for (longPrime in longPrimes) {
    if (longPrime > numbers[index]) {
        totals[index] = count
        index = index + 1
    }
    count = count + 1
}
totals[-1] = count
System.print("The long primes up to %(numbers[0]) are: ")
System.print(longPrimes[0...totals[0]].join(" "))

System.print("\nThe number of long primes up to: ")
var i = 0
for (total in totals) {
    Fmt.print("  $5d is $d", numbers[i], total)
    i = i + 1
}
