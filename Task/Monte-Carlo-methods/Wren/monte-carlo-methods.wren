import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()

var mcPi = Fn.new { |n|
    var inside = 0
    for (i in 1..n) {
        var x = rand.float()
        var y = rand.float()
        if (x*x + y*y <= 1) inside = inside + 1
    }
    return 4 * inside / n
}

System.print("Iterations -> Approx Pi  -> Error\%")
System.print("----------    ----------    ------")
var n = 1000
while (n <= 1e8) {
    var pi = mcPi.call(n)
    var err = (Num.pi - pi).abs / Num.pi * 100.0
    Fmt.print("$9d  -> $10.8f -> $6.4f", n, pi, err)
    n = n * 10
}
