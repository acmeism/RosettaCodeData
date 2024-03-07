import "./fmt" for Fmt
import "./math" for Int

var limit = 999999
var c = Int.primeSieve(limit, false)
var leftFound = false
var rightFound = false
System.print("Largest truncatable primes less than a million:")
var i = limit
while (i > 2) {
    if (!c[i]) {
        if (!rightFound) {
            var p = (i/10).floor
            while (p > 0) {
                if (p%2 == 0 || c[p]) break
                p = (p/10).floor
            }
            if (p == 0) {
                System.print("  Right truncatable prime = %(Fmt.dc(0, i))")
                rightFound = true
                if (leftFound) return
            }
        }
        if (!leftFound) {
            var q = i.toString[1..-1]
            if (!q.contains("0")) {
                var p = Num.fromString(q)
                while (q.count > 0) {
                    if (p%2 == 0 || c[p]) break
                    q = q[1..-1]
                    p = Num.fromString(q)
                }
                if (q == "") {
                    System.print("  Left truncatable prime  = %(Fmt.dc(0, i))")
                    leftFound = true
                    if (rightFound) return
                }
            }
        }
    }
    i = i - 2
}
