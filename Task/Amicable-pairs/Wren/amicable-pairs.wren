import "./fmt" for Fmt
import "./math" for Int, Nums

var a = List.filled(20000, 0)
for (i in 1...20000) a[i] = Nums.sum(Int.properDivisors(i))
System.print("The amicable pairs below 20,000 are:")
for (n in 2...19999) {
    var m = a[n]
    if (m > n && m < 20000 && n == a[m]) {
        Fmt.print("  $5d and $5d", n, m)
    }
}
