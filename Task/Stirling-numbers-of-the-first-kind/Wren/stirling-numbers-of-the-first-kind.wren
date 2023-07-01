import "/big" for BigInt
import "/fmt" for Fmt

var computed = {}

var stirling1 // recursive
stirling1 = Fn.new { |n, k|
    var key = "%(n),%(k)"
    if (computed.containsKey(key)) return computed[key]
    if (n == 0 && k == 0) return BigInt.one
    if (n > 0 && k == 0) return BigInt.zero
    if (k > n) return BigInt.zero
    var result = stirling1.call(n-1, k-1) + stirling1.call(n-1, k)*(n-1)
    computed[key] = result
    return result
}

System.print("Unsigned Stirling numbers of the first kind:")
var max = 12
System.write("n/k")
for (n in 0..max) Fmt.write("$10d", n)
System.print()
for (n in 0..max) {
    Fmt.write("$-3d", n)
    for (k in 0..n) Fmt.write("$10i", stirling1.call(n, k))
    System.print()
}
System.print("The maximum value of S1(100, k) =")
var previous = BigInt.zero
for (k in 1..100) {
    var current = stirling1.call(100, k)
    if (current > previous) {
        previous = current
    } else {
        Fmt.print("$i\n($d digits, k = $d)", previous, previous.toString.count, k - 1)
        break
    }
}
