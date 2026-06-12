var signum = Fn.new { |i|
    if (!((i is Num) && i.isInteger)) Fiber.abort("Argument must be an integer.")
    return i > 0 ? 1 : i < 0 ? -1 : Object.same(i, -0) ? -0 : 0
}

var ints = [5, 0, -5, -0]
for (i in ints) System.print("%(i) -> %(signum.call(i))")
