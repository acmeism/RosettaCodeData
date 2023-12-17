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

System.print("Additive primes less than 500:")
var primes = Int.primeSieve(499)
var count = 0
for (p in primes) {
    if (Int.isPrime(sumDigits.call(p))) {
        count = count + 1
        Fmt.write("$3d  ", p)
        if (count % 10 == 0) System.print()
    }
}
System.print("\n\n%(count) additive primes found.")
