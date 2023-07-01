var nthRoot = Fn.new { |x, n|
    if (n < 2) Fiber.abort("n must be more than 1")
    if (x <= 0) Fiber.abort("x must be positive")
    var np = n - 1
    var iter = Fn.new { |g| (np*g + x/g.pow(np))/n }
    var g1 = x
    var g2 = iter.call(g1)
    while (g1 != g2) {
        g1 = iter.call(g1)
        g2 = iter.call(iter.call(g2))
    }
    return g1
}

var trios = [ [1728, 3, 2], [1024, 10, 1], [2, 2, 5] ]
for (trio in trios) {
    System.print("%(trio[0]) ^ 1/%(trio[1])%(" "*trio[2]) = %(nthRoot.call(trio[0], trio[1]))")
}
