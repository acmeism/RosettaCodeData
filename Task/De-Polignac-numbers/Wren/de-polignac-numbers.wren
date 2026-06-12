import "./math" for Int
import "./fmt" for Fmt

var pows2 = (0..19).map { |i| 1 << i }.toList
var dp = [1]
var dp1000
var dp10000
var count = 1
var n = 3
while (true) {
    var found = false
    for (pow in pows2) {
        if (pow > n) break
        if (Int.isPrime(n-pow)) {
            found = true
            break
        }
    }
    if (!found) {
        count = count + 1
        if (count <= 50) {
            dp.add(n)
        } else if (count == 1000) {
            dp1000 = n
        } else if (count == 10000) {
            dp10000 = n
            break
        }
    }
    n = n + 2
}
System.print("First 50 De Polignac numbers:")
Fmt.tprint("$,5d", dp, 10)
Fmt.print("\nOne thousandth: $,d", dp1000)
Fmt.print("\nTen thousandth: $,d", dp10000)
