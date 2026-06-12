import "./math" for Int
import "./iterate" for Stepped
import "./fmt" for Fmt

var primes = []
for (seq in [ 3..3, 33..33, Stepped.new(303..393, 10), Stepped.new(3003..3993, 10) ]) {
    for (e in seq) if (Int.isPrime(e)) primes.add(e)
}
System.print("Primes under 4,000 which begin and end in 3:")
Fmt.tprint("$,5d", primes, 11)
System.print("\nFound %(primes.count) such primes.")
