import "./fmt" for Fmt
import "./big" for BigRat

var bernoulli = Fn.new { |n|
    if (n < 0) Fiber.abort("Argument must be non-negative")
    var a = List.filled(n+1, null)
    for (m in 0..n) {
        a[m] = BigRat.new(1, m+1)
        var j = m
        while (j >= 1) {
            a[j-1] = (a[j-1] - a[j]) * BigRat.new(j, 1)
            j = j - 1
        }
    }
    return (n != 1) ? a[0] : -a[0] // 'first' Bernoulli number
}

for (n in 0..60) {
    var b = bernoulli.call(n)
    if (b != BigRat.zero) Fmt.print("B($2d) = $44i / $i", n, b.num, b.den)
}
