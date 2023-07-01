import "/fmt" for Fmt

var integrate = Fn.new { |a, b, n, f|
    var h = (b - a) / n
    var sum = List.filled(5, 0)
    for (i in 0...n) {
        var x = a + i * h
        sum[0] = sum[0] + f.call(x)
        sum[1] = sum[1] + f.call(x + h/2)
        sum[2] = sum[2] + f.call(x + h)
        sum[3] = sum[3] + (f.call(x) + f.call(x+h))/2
        sum[4] = sum[4] + (f.call(x) + 4 * f.call(x + h/2) + f.call(x + h))/6
    }
    var methods = ["LeftRect ", "MidRect  ", "RightRect", "Trapezium", "Simpson  "]
    for (i in 0..4) Fmt.print("$s = $h", methods[i], sum[i] * h)
    System.print()
}

integrate.call(0, 1, 100)        { |v| v * v * v }
integrate.call(1, 100, 1000)     { |v| 1 / v }
integrate.call(0, 5000, 5000000) { |v| v }
integrate.call(0, 6000, 6000000) { |v| v }
