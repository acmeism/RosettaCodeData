import "./fmt" for Fmt
import "./math" for Nums

var cumStdDev = Fiber.new { |a|
    for (i in 0...a.count) {
        var b = a[0..i]
        System.print("Values  : %(b)")
        Fiber.yield(Nums.popStdDev(b))
    }
}

var a = [2, 4, 4, 4, 5,  5, 7, 9]
while (true) {
    var sd = cumStdDev.call(a)
    if (cumStdDev.isDone) return
    Fmt.print("Std Dev : $10.8f\n", sd)
}
