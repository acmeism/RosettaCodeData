import "/big" for BigInt, BigInts
import "/fmt" for Fmt

var min = 3
var max = 9
var prod = BigInt.zero
var fact = BigInt.zero
var factors = List.filled(max, 0)
var bigFactors = List.filled(max, null)

var init = Fn.new {
    for (i in 0...max) bigFactors[i] = BigInt.zero
}

var isPrimePretest = Fn.new { |k|
    if (k%3 == 0 || k%5 == 0 || k%7 == 0 || k%11 == 0 ||
       (k%13 == 0) || k%17 == 0 || k%19 == 0 || k%23 == 0) return k <= 23
    return true
}

var ccFactors = Fn.new { |n, m|
    if (!isPrimePretest.call(6*m + 1)) return false
    if (!isPrimePretest.call(12*m + 1)) return false
    factors[0] = 6*m + 1
    factors[1] = 12*m + 1
    var t = 9 * m
    var i = 1
    while (i <= n-2) {
        var tt = (t << i) + 1
        if (!isPrimePretest.call(tt)) return false
        factors[i+1] = tt
        i = i + 1
    }
    for (i in 0...n) {
        fact = BigInt.new(factors[i])
        if (!fact.isProbablePrime(1)) return false
        bigFactors[i] = fact
    }
    return true
}

var ccNumbers = Fn.new { |start, end|
    for (n in start..end) {
        var mult = 1
        if (n > 4) mult = 1 << (n - 4)
        if (n > 5) mult = mult * 5
        var m = mult
        while (true) {
            if (ccFactors.call(n, m)) {
                var num = BigInts.prod(bigFactors.take(n))
                Fmt.print("a($d) = $i", n, num)
                Fmt.print("m($d) = $d", n, m)
                Fmt.print("Factors: $n\n", factors[0...n])
                break
            }
            m = m + mult
        }
    }
}

init.call()
ccNumbers.call(min, max)
