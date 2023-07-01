import "/fmt" for Fmt

var isPrime = Fn.new { |n|
    if (n < 2) return false
    if (n%2 == 0) return n == 2
    var p = 3
    while (p * p <= n) {
        if (n%p == 0) return false
        p = p + 2
    }
    return true
}

var tests = [2, 5, 12, 19, 57, 61, 97]
System.print("Are the following prime?")
for (test in tests) {
    System.print("%(Fmt.d(2, test)) -> %(isPrime.call(test) ? "yes" : "no")")
}
