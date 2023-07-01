import "./fmt" for Fmt

var limits = [3..10, 11..18, 19..36, 37..54, 55..86, 87..118]

var periodicTable = Fn.new { |n|
    if (n < 1 || n > 118) Fiber.abort("Atomic number is out of range.")
    if (n == 1) return [1, 1]
    if (n == 2) return [1, 18]
    if (n >= 57 && n <= 71)  return [8, n - 53]
    if (n >= 89 && n <= 103) return [9, n - 85]
    var row
    var start
    var end
    for (i in 0...limits.count) {
        var limit = limits[i]
        if (n >= limit.from && n <= limit.to) {
            row = i + 2
            start = limit.from
            end = limit.to
            break
        }
    }
    if (n < start + 2 || row == 4 || row == 5) return [row, n - start + 1]
    return [row, n - end + 18]
}

for (n in [1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113]) {
    var rc = periodicTable.call(n)
    Fmt.print("Atomic number $3d -> $d, $-2d", n, rc[0], rc[1])
}
