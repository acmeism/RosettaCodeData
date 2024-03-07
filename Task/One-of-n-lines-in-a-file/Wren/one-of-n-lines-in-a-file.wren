import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()

var oneOfN = Fn.new { |n|
    var choice = 1
    for (i in 2..n) {
        if (rand.float() < 1/i) choice = i
    }
    return choice
}

var n = 10
var freqs = List.filled(n, 0)
var reps = 1e6
for (i in 0...reps) {
    var num = oneOfN.call(n)
    freqs[num-1] = freqs[num-1] + 1
}
for (i in 1..n) Fmt.print("Line $-2d = $,7d", i, freqs[i-1])
