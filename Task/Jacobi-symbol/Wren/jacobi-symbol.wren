import "./fmt" for Fmt

var jacobi = Fn.new { |a, n|
    if (!n.isInteger || n <= 0 || n%2 == 0) {
        Fiber.abort("The 'n' parameter must be an odd positive integer.")
    }
    a = a % n
    var result = 1
    while (a != 0) {
        while (a%2  == 0) {
            a = a / 2
            var nm8 = n % 8
            if ([3, 5].contains(nm8)) result = -result
        }
        var t = a
        a = n
        n = t
        if (a%4 == 3 && n%4 == 3) result = -result
        a = a % n
    }
    return (n == 1) ? result : 0
}

System.print("Table of jacobi(a, n):")
System.print("n/a   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15")
System.print("---------------------------------------------------------------")
var n = 1
while (n < 31) {
    Fmt.write("$3d", n)
    for (a in 1..15) Fmt.write("$4d", jacobi.call(a, n))
    System.print()
    n = n + 2
}
