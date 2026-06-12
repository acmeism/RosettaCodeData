import "./math" for Int
import "./iterate" for Stepped
import "./fmt" for Fmt

var getQualifyingPrimes = Fn.new { |x, d|
    if (d.type != Num || !d.isInteger || d < 1) Fiber.abort("Invalid number of digits.")
    if (x == 2 || x == 5) return [x]
    if (x % 2 == 0) return []
    var primes = []
    var candidates = [x]
    for (i in 1...d) {
        var pow = 10.pow(i)
        var start = x * (pow + 1)
        var end = start + pow - 10
        candidates.addAll(Stepped.new(start..end, 10).toList)
    }
    return candidates.where { |cand| Int.isPrime(cand) }.toList
}

var d = 4  // up to 'd' digits
for (x in [1, 2, 3, 5, 7, 9]) { // begins and ends with 'x'
    var primes = getQualifyingPrimes.call(x, d)
    var len = d + ((d-1)/3).floor
    Fmt.print("Primes under $,%(len)d which begin and end in $d:", 10.pow(d), x)
    Fmt.tprint("$,%(len)d", primes, 10)
    System.print("\nFound %(primes.count) such primes.\n")
}

d = 6
for (x in [1, 3, 7, 9]) {
    var primes = getQualifyingPrimes.call(x, d)
    Fmt.print("Found $,d primes under $,d which begin and end with $d.\n", primes.count, 10.pow(d), x)
}
