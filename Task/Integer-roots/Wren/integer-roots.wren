import "./big" for BigInt

// only use for integers less than 2^53
var intRoot = Fn.new { |x, n|
    if (!(x is Num && x.isInteger && x >= 0)) {
        Fiber.abort("First argument must be a non-negative integer.")
    }
    if (!(n is Num && x.isInteger && x >= 1)) {
        Fiber.abort("Second argument must be a positive integer.")
    }
    return x.pow(1/n).floor
}

var a = [ [8, 3], [9, 3], [2e18, 2] ]
for (e in a) {
    var x = e[0]
    var n = e[1]
    System.print("%(x) ^ (1/%(n)) = %(intRoot.call(x, n))")
}

System.print("\nFirst 2001 digits of the square root of 2:")
System.print((BigInt.two * BigInt.new(100).pow(2000)).isqrt)
