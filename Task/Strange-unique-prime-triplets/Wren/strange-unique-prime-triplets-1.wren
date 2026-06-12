import "./math" for Int
import "./iterate" for Stepped
import "./fmt" for Fmt

var strangePrimes = Fn.new { |n, countOnly|
    var c = 0
    var s
    for (i in Stepped.new(3..n-4, 2)) {
        if (Int.isPrime(i)) {
            for (j in Stepped.new(i+2..n-2, 2)) {
                if (Int.isPrime(j)) {
                    for (k in Stepped.new(j+2..n, 2)) {
                        if (Int.isPrime(k) && Int.isPrime(s = i + j + k)) {
                            c = c + 1
                            if (!countOnly) Fmt.print("$2d: $2d + $2d + $2d = $2d", c, i, j, k, s)
                        }
                    }
                }
            }
        }
    }
    return c
}

System.print("Unique prime triples under 30 which sum to a prime:")
strangePrimes.call(29, false)
var c = strangePrimes.call(999, true)
Fmt.print("\nThere are $,d unique prime triples under 1,000 which sum to a prime.", c)
