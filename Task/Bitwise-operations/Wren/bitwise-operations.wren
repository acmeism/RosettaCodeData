var rl = Fn.new { |x, y| x << y | x >> (32-y) }

var rr = Fn.new { |x, y| x >> y | x << (32-y) }

var bitwise = Fn.new { |x, y|
    if (!x.isInteger || !y.isInteger || x < 0 || y < 0 || x > 0xffffffff || y > 0xffffffff) {
        Fiber.abort("Operands must be in the range of a 32-bit unsigned integer")
    }
    System.print(" x      = %(x)")
    System.print(" y      = %(y)")
    System.print(" x & y  = %(x & y)")
    System.print(" x | y  = %(x | y)")
    System.print(" x ^ y  = %(x ^ y)")
    System.print("~x      = %(~x)")
    System.print(" x << y = %(x << y)")
    System.print(" x >> y = %(x >> y)")
    System.print(" x rl y = %(rl.call(x, y))")
    System.print(" x rr y = %(rr.call(x, y))")
}

bitwise.call(10, 2)
