import "./set" for Set
import "./math" for Int
import "./fmt" for Fmt

var ascPrimes = Set.new() // avoids duplicates

var generate  // recursive function
generate = Fn.new { |first, cand, digits|
    if (digits == 0) {
        if (Int.isPrime(cand)) ascPrimes.add(cand)
        return
    }
    var i = first
    while (i <= 9) {
        var next = cand * 10 + i
        generate.call(i + 1, next, digits - 1)
        i = i + 1
    }
}

for (digits in 1..9) generate.call(1, 0, digits)
ascPrimes = ascPrimes.toList
ascPrimes.sort()
System.print("There are %(ascPrimes.count) ascending primes, namely:")
Fmt.tprint("$8d", ascPrimes, 10)
