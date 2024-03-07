import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()

var biased = Fn.new { |n| rand.float() < 1 / n }

var unbiased = Fn.new { |n|
    while (true) {
        var a = biased.call(n)
        var b = biased.call(n)
        if (a != b) return a
    }
}

var m = 50000
var f = "$d: $2.2f\%  $2.2f\%"
for (n in 3..6) {
    var c1 = 0
    var c2 = 0
    for (i in 0...m) {
        if (biased.call(n)) c1 = c1 + 1
        if (unbiased.call(n)) c2 = c2 + 1
    }
    Fmt.print(f, n, 100 * c1 / m, 100 * c2 / m)
}
