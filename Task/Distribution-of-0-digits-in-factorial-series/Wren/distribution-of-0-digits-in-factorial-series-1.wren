import "/big" for BigInt
import "/fmt" for Fmt

var fact = BigInt.one
var sum = 0
System.print("The mean proportion of zero digits in factorials up to the following are:")
for (n in 1..10000) {
    fact = fact * n
    var bytes = fact.toString.bytes
    var digits = bytes.count
    var zeros  = bytes.count { |b| b == 48 }
    sum = sum + zeros / digits
    if (n == 100 || n == 1000 || n == 10000) {
        Fmt.print("$,6d = $12.10f", n, sum / n)
    }
}
