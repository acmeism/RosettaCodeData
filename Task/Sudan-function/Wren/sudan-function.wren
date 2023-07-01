import "./fmt" for Fmt

var F = Fn.new { |n, x, y|
    if (n == 0) return x + y
    if (y == 0) return x
    return F.call(n - 1, F.call(n, x, y-1), F.call(n, x, y-1) + y)
}

for (n in 0..1) {
    System.print("Values of F(%(n), x, y):")
    System.print("y/x    0   1   2   3   4   5")
    System.print("----------------------------")
    for (y in 0..6) {
        System.write("%(y)  |")
        for (x in 0..5) {
            var sudan = F.call(n, x, y)
            Fmt.write("$4d", sudan)
        }
        System.print()
    }
    System.print()
}
System.print("F(2, 1, 1) = %(F.call(2, 1, 1))")
System.print("F(3, 1, 1) = %(F.call(3, 1, 1))")
System.print("F(2, 2, 1) = %(F.call(2, 2, 1))")
