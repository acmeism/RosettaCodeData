var listDivide = Fn.new { |a, n|
    if (!(a is List)) Fiber.abort("'a' must be a List.")
    if (!(n is Num && n.isInteger && n > 0)) {
        Fiber.abort("'n' must be a positive integer.")
    }
    var c = a.count
    var q = (c / n).floor
    var r = c % n
    var p = [q + 1] * r
    // Only include non-empty parts.
    if (q > 0) p = p + [q] * (n - r)
    var pc = p.count
    var res = List.filled(pc, null)
    var start = 0
    for (i in 0...pc) {
        var end = start + p[i]
        res[i] = a[start...end]
        start = end
    }
    return res
}

var tests = [
    [[94, 94, 13, 77, 35, 10, 51, 27, 60], 6],
    [[19, 46, 43, 17, 94], 1],
    [[93, 88, 40, 88, 30, 68, 84, 25], 3],
    [[88, 94, 10, 27, 54, 14], 3],
    [[31, 19, 63, 57, 57, 74, 50, 14, 38], 4],
    [[72, 57, 89, 55, 36, 84, 10, 95, 99, 35], 7],
    // For the next 3 tests, the function partitions as far as it can.
    [[23, 49, 57], 10],
    [[1], 2],
    [[], 2]
]
for (test in tests) {
    var a = test[0]
    var n = test[1]
    System.print(listDivide.call(a, n))
}
