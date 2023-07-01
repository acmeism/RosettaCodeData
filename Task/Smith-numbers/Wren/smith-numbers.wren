import "/math" for Int
import "/fmt" for Fmt
import "/seq" for Lst

var sumDigits = Fn.new { |n|
    var sum = 0
    while (n > 0) {
        sum = sum + n%10
        n = (n/10).floor
    }
    return sum
}

var smiths = []
System.print("The Smith numbers below 10,000 are:")
for (i in 2...10000) {
    if (!Int.isPrime(i)) {
        var thisSum = sumDigits.call(i)
        var factors = Int.primeFactors(i)
        var factSum = factors.reduce(0) { |acc, f| acc + sumDigits.call(f) }
        if (thisSum == factSum) smiths.add(i)
    }
}
for (chunk in Lst.chunks(smiths, 16)) Fmt.print("$4d", chunk)
