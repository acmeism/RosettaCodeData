import "./fmt" for Conv, Fmt

var isVile = Fn.new { |n|
    if (n % 2 == 1) return true
    var b = Conv.itoa(n, 2)
    var l1 = b.count
    var c = b.trimEnd("0")
    var l2 = c.count
    return (l1 - l2) % 2 == 0
}

var viles = []
var dopeys = []
var n = 1
while (viles.count < 25 || dopeys.count < 25) {
    if (isVile.call(n)) viles.add(n) else dopeys.add(n)
    n = n + 1
}
System.print("First 25 Vile numbers:")
Fmt.tprint("$2d ", viles[0..24], 5)
System.print()
System.print("First 25 Dopey numbers:")
Fmt.tprint("$2d ", dopeys[0..24], 5)
System.print("\nupto:  Vile  Dopey")
var limit = 2
var vc = 0
var dc = 0
n = 1
while (n <= limit) {
    if (isVile.call(n)) vc = vc + 1 else dc = dc + 1
    if (n == limit) {
        Fmt.print("$4d:   $3d    $3d", limit, vc, dc)
        if (limit == 1024) break
        limit = limit * 2
    }
    n = n + 1
}
