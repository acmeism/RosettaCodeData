import "./fmt" for Fmt

var limit = 1<<20 + 1
var a = List.filled(limit, 0)
a[1] = 1
a[2] = 1
for (n in 3...limit) {
    var p = a[n-1]
    a[n] = a[p] + a[n-p]
}

System.print("     Range          Maximum")
System.print("----------------   --------")
var pow2 = 1
var p = 1
var max = a[1]
for (n in 2...limit) {
    var r = a[n] / n
    if (r > max) max = r
    if (n == pow2 * 2) {
        Fmt.print("2 ^ $2d to 2 ^ $2d   $f", p - 1, p, max)
        pow2 = pow2 * 2
        p = p + 1
        max = r
    }
}

var prize = 0
for (n in limit-1..1) {
    if (a[n]/n >= 0.55) {
        prize = n
        break
    }
}
System.print("\nMallows' number = %(prize)")
