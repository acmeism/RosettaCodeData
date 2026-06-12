import "./math" for Int, Nums
import "./seq" for Lst
import "./fmt" for Fmt

var limit = 1000
var calmo = []
for (i in 2...limit) {
    var ed = Int.properDivisors(i)
    ed.removeAt(0)
    if (ed.count == 0 || ed.count % 3 != 0) continue
    var isCalmo = true
    var ps = []
    for (chunk in Lst.chunks(ed, 3)) {
        var sum = Nums.sum(chunk)
        if (!Int.isPrime(sum)) {
            isCalmo = false
            break
        }
        ps.add(sum)
    }
    if (isCalmo) calmo.add([i, ed, ps])
}
System.print("Calmo numbers under 1,000:\n")
System.print("Number  Eligible divisors         Partial sums")
System.print("----------------------------------------------")
for (e in calmo) {
    Fmt.print("$3d     $-24n  $n", e[0], e[1], e[2])
}
