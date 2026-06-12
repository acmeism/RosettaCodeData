import "./math" for Int
import "./iterate" for Stepped
import "./fmt" for Fmt

var sumDigits = Fn.new { |n|
    var sum = 0
    while (n > 0) {
        sum = sum + (n % 10)
        n = (n/10).floor
    }
    return sum
}

System.print("Nice primes in the interval (500, 900) are:")
var c = 0
for (i in Stepped.new(501..999, 2)) {
    if (Int.isPrime(i)) {
        var s = i
        while (s >= 10) s = sumDigits.call(s)
        if (Int.isPrime(s)) {
            c = c + 1
            Fmt.print("$2d: $d -> Σ = $d", c, i, s)
        }
    }
}
