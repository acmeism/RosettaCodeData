import "./fmt" for Conv, Fmt

var magicSquareDoublyEven = Fn.new { |n|
    if (n < 4 || n%4 != 0) Fiber.abort("Base must be a positive multiple of 4")

    // pattern of count-up vs count-down zones
    var bits = Conv.atoi("1001011001101001", 2)
    var size = n * n
    var mult = (n/4).floor // how many multiples of 4
    var result = List.filled(n, null)
    for (i in 0...n) result[i] = List.filled(n, 0)
    var i = 0
    for (r in 0...n) {
        for (c in 0...n) {
            var bitPos = (c/mult).floor + (r/mult).floor * 4
            result[r][c] = ((bits & (1<<bitPos)) != 0) ? i + 1 : size - i
            i = i + 1
        }
    }
    return result
}

var n = 8
for (ia in magicSquareDoublyEven.call(n)) {
    for (i in ia) Fmt.write("$2d  ", i)
    System.print()
}
System.print("\nMagic constant %((n * n + 1) * n / 2)")
