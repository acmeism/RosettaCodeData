var pythTriples = Fiber.new { |n|
    (1..n-2).each { |x|
        (x+1..n-1).each { |y|
            (y+1..n).each { |z| (x*x + y*y == z*z) && Fiber.yield([x, y, z]) }
        }
    }
}

var n = 20
while (!pythTriples.isDone) {
    var res = pythTriples.call(n)
    res && System.print(res)
}
