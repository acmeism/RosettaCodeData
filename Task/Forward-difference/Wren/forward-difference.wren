import "./fmt" for Fmt

var forwardDiff = Fn.new { |a, order|
    if (order < 0) Fiber.abort("Order must be a non-negative integer.")
    if (a.count == 0) return
    Fmt.print(" 0: $5d", a)
    if (a.count == 1) return
    if (order == 0) return
    for (o in 1..order) {
        var b = List.filled(a.count-1, 0)
        for (i in 0...b.count) b[i] = a[i+1] - a[i]
        Fmt.print("$2d: $5d", o, b)
        if (b.count == 1) return
        a = b
    }
}

forwardDiff.call([90, 47, 58, 29, 22, 32, 55, 5, 55, 73], 9)
