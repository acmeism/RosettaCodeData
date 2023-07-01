import "./perm" for Comb

var fib = Fiber.new { Comb.generate((0..4).toList, 3) }
while (true) {
    var c = fib.call()
    if (!c) return
    System.print(c)
}
