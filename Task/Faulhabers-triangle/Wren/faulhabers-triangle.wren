import "./fmt" for Fmt
import "./math" for Int
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

var binomial = Fn.new { |n, k|
    if (n < 0 || k < 0) Fiber.abort("Arguments must be non-negative integers")
    if (n < k) Fiber.abort("The second argument cannot be more than the first.")
    if (n == k) return 1
    var prod = 1
    var i = n - k + 1
    while (i <= n) {
        prod = prod * i
        i = i + 1
    }
    return prod / Int.factorial(k)
}

var faulhaberTriangle = Fn.new { |p|
    var coeffs = List.filled(p+1, null)
    var q = BigRat.new(1, p+1)
    var sign = -1
    for (j in 0..p) {
        sign = sign * -1
        var b = BigRat.new(binomial.call(p+1, j), 1)
        coeffs[p-j] = q * BigRat.new(sign, 1) * b * bernoulli.call(j)
    }
    return coeffs
}

BigRat.showAsInt = true
for (i in 0..9) {
    var coeffs = faulhaberTriangle.call(i)
    for (coeff in coeffs) Fmt.write("$5s ", coeff)
    System.print()
}
System.print()
 // get coeffs for (k + 1)th row
var k = 17
var cc = faulhaberTriangle.call(k)
var n = BigRat.new(1000, 1)
var np = BigRat.one
var sum = BigRat.zero
for (c in cc) {
    np = np * n
    sum = sum + np*c
}
System.print(sum)
