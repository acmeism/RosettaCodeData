import "/fmt" for Fmt

var isPrime = Fn.new { |n|
    if (n < 2 || !n.isInteger) return false
    if (n%2 == 0) return n == 2
    if (n%3 == 0) return n == 3
    var d = 5
    while (d*d <= n) {
        if (n%d == 0) return false
        d = d + 2
        if (n%d == 0) return false
        d = d + 4
    }
    return true
}

var count = 0
var i = 42
while (count < 42) {
    if (isPrime.call(i)) {
        count = count + 1
        System.print("%(Fmt.d(2, count)): %(Fmt.dc(18, i))")
        i = 2 * i - 1
    }
    i = i + 1
}
