import "./math" for Int
import "./fmt" for Fmt

var nonDescending = Fn.new { |p|
    var digits = []
    while (p > 0) {
        digits.add(p % 10)
        p = (p/10).floor
    }
    for (i in 0...digits.count-1) {
        if (digits[i+1] > digits[i]) return false
    }
    return true
}

var primes = Int.primeSieve(999)
var nonDesc = []
for (p in primes) if (nonDescending.call(p)) nonDesc.add(p)
System.print("Primes below 1,000 with digits in non-decreasing order:")
Fmt.tprint("$3d", nonDesc, 10)
System.print("\n%(nonDesc.count) such primes found.")
