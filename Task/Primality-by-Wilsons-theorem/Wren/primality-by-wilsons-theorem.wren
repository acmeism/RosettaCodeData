import "./gmp" for Mpz
import "./fmt" for Fmt

var t = Mpz.new()

var wilson = Fn.new { |p|
    if (p < 2) return false
    return (t.factorial(p-1) + 1) % p == 0
}

var primes = [2]
var i = 3
while (primes.count < 1015) {
    if (wilson.call(i)) primes.add(i)
    i = i + 2
}

var candidates = [2, 3, 9, 15, 29, 37, 47, 57, 67, 77, 87, 97, 237, 409, 659]
System.print("  n | prime?\n------------")
for (cand in candidates) Fmt.print("$3d | $s", cand, wilson.call(cand))

System.print("\nThe first 120 prime numbers by Wilson's theorem are:")
Fmt.tprint("$3d", primes[0..119], 20)

System.print("\nThe 1,000th to 1,015th prime numbers are:")
System.print(primes[-16..-1].join(" "))
