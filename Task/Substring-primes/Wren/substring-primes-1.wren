import "./math" for Int
var primes = Int.primeSieve(499)
var sprimes = []
for (p in primes) {
    var digits = Int.digits(p)
    var b1 = digits.all { |d| Int.isPrime(d) }
    if (b1) {
        if (digits.count < 3) {
            sprimes.add(p)
        } else {
            var b2 = Int.isPrime(digits[0] * 10 + digits[1])
            var b3 = Int.isPrime(digits[1] * 10 + digits[2])
            if (b2 && b3) sprimes.add(p)
        }
    }
}
System.print("Found %(sprimes.count) primes < 500 where all substrings are also primes, namely:")
System.print(sprimes)
