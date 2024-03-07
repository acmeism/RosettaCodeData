import "./fmt" for Fmt

var isIntegral = Fn.new { |x, tol| x.fraction.abs <= tol }

var pascal = Fn.new { |a, b, mid, top|
    var yd = (top - 4 * (a + b)) / 7
    if (!isIntegral.call(yd, 0.0001)) return [0, 0, 0]
    var y = yd.truncate
    var x = mid - 2*a - y
    return [x, y, y - x]
}

var sol = pascal.call(11, 4, 40, 151)
if (sol[0] != 0) {
    Fmt.print("Solution is: x = $d, y = $d, z = $d", sol[0], sol[1], sol[2])
} else {
    System.print("There is no solution")
}
