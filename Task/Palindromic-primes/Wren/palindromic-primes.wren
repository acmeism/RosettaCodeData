import "./math" for Int
import "./fmt" for Fmt

var reversed = Fn.new { |n|
    var rev = 0
    while (n > 0) {
        rev = rev * 10 + n % 10
        n = (n/10).floor
    }
    return rev
}

var primes = Int.primeSieve(99999)
var pals = []
for (p in primes) {
    if (p == reversed.call(p)) pals.add(p)
}
System.print("Palindromic primes under 1,000:")
var smallPals = pals.where { |p| p < 1000 }.toList
Fmt.tprint("$3d", smallPals, 10)
System.print("\n%(smallPals.count) such primes found.")

System.print("\nAdditional palindromic primes under 100,000:")
var bigPals = pals.where { |p| p >= 1000 }.toList
Fmt.tprint("$,6d", bigPals, 10)
System.print("\n%(bigPals.count) such primes found, %(pals.count) in all.")
