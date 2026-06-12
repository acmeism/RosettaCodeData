var start = System.clock
var sends = []
var ors = []
var m = 1
var digits = (0..9).toList
digits.remove(m)
for (s in 8..9) {
    for (e in digits) {
        if (e == s) continue
        for (n in digits) {
            if (n == s || n == e) continue
            for (d in digits) {
                if (d == s || d == e || d == n) continue
                sends.add([s, e, n, d])
            }
        }
    }
}
for (o in digits) {
    for (r in digits) {
        if (r == o) continue
        ors.add([o, r])
    }
}
System.print("Solution(s):")
for (send in sends) {
    var SEND = 1000 * send[0] + 100 * send[1] + 10 * send[2] + send[3]
    for (or in ors) {
        if (send.contains(or[0]) || send.contains(or[1])) continue
        var MORE = 1000 * m + 100 * or[0] + 10 * or[1] + send[1]
        for (y in digits) {
            if (send.contains(y) || or.contains(y)) continue
            var MONEY = 10000 * m + 1000 * or[0] + 100 * send[2] + 10 * send[1] + y
            if (SEND + MORE == MONEY) {
                System.print("%(SEND) + %(MORE) = %(MONEY)")
            }
        }
    }
}
System.print("\nTook %(System.clock - start) seconds.")
