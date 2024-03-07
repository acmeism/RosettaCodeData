import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()
var RAND_MAX = 32767

// just generate 0s and 1s without storing them
var runTest = Fn.new { |p, len, runs|
    var cnt = 0
    var thresh = (p * RAND_MAX).truncate
    for (r in 0...runs) {
        var x = 0
        var i = len
        while (i > 0) {
            i = i - 1
            var y = (rand.int(RAND_MAX + 1) < thresh) ? 1 : 0
            if (x < y) cnt = cnt + 1
            x = y
        }
    }
    return cnt / runs / len
}

System.print("Running 1000 tests each:")
System.print(" p\t   n\tK\tp(1-p)\t     diff")
System.print("------------------------------------------------")
var fmt = "$.1f\t$6d\t$.4f\t$.4f\t$+.4f ($+.2f\%)"
for (ip in [1, 3, 5, 7, 9]) {
    var p = ip / 10
    var p1p = p * (1 - p)
    var n = 100
    while (n <= 1e5) {
        var k = runTest.call(p, n, 1000)
        Fmt.lprint(fmt, [p, n, k, p1p, k - p1p, (k - p1p) /p1p * 100])
        n = n * 10
    }
    System.print()
}
