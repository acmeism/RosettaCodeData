import "./math" for Int
import "./seq" for Lst
import "./fmt" for Fmt

var count = 0
var k = 11 * 11
var res = []
while (count < 20) {
    if (k % 3 == 0 || k % 5 == 0 || k % 7 == 0) {
        k = k + 2
        continue
    }
    var factors = Int.primeFactors(k)
    if (factors.count > 1) {
        Lst.prune(factors)
        var s = k.toString
        var includesAll = true
        for (f in factors) {
            if (s.indexOf(f.toString) == -1) {
                includesAll = false
                break
            }
        }
        if (includesAll) {
            res.add(k)
            count = count + 1
        }
    }
    k = k + 2
}
Fmt.print("$,10d", res[0..9])
Fmt.print("$,10d", res[10..19])
