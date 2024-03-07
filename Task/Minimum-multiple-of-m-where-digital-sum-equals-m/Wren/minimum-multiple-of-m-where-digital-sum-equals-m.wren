import "./math" for Int
import "./seq" for Lst
import "./fmt" for Fmt

var res = []
for (n in 1..70) {
    var m = 1
    while (Int.digitSum(m * n) != n) m = m + 1
    res.add(m)
}
Fmt.tprint("$,10d", res, 10)
