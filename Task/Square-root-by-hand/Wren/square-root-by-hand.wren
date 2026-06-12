import "./big" for BigInt

var sqrt = Fn.new { |n, limit|
    if (n < 0) Fiber.abort("Number cannot be negative.")
    var count = 0
    while (!n.isInteger) {
        n = n * 100
        count = count - 1
    }
    var i = BigInt.new(n)
    var j = i.isqrt
    count = count + j.toString.count
    var k = j
    var d = j
    var digits = 0
    var root = ""
    while (digits < limit) {
        root = root + d.toString
        i = (i - k*d) * 100
        k = j * 20
        d = BigInt.one
        while (d <= 10) {
            if ((k + d)*d > i) {
                d = d.dec
                break
            }
            d = d.inc
        }
        j = j*10 + d
        k = k + d
        digits = digits + 1
    }
    root = root.trimEnd("0")
    if (root == "") root = "0"
    if (count > 0) {
        root = root[0...count] + "." + root[count..-1]
    } else if (count == 0) {
        root = "0." + root
    } else {
        root = "0." + ("0" * (-count)) + root
    }
    if (root[-1] == ".") root = root[0..-2]
    System.print(root)
}

var numbers = [2, 0.2, 10.89, 625, 0.0001]
var digits = [500, 80, 8, 8, 8]
var i = 0
for (n in numbers) {
    System.print("First %(digits[i]) significant digits (at most) of the square root of %(n):")
    sqrt.call(n, digits[i])
    System.print()
    i = i + 1
}
