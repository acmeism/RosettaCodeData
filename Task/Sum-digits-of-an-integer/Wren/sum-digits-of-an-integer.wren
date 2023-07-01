import "/fmt" for Fmt, Conv

var sumDigits = Fn.new { |n, b|
    var sum = 0
    while (n > 0) {
        sum = sum + n%b
        n = (n/b).truncate
    }
    return sum
}

var tests = [ [1, 10], [1234, 10], [0xfe, 16], [0xf0e, 16], [1411, 8], [111, 3] ]
System.print("The sum of the digits is:")
for (test in tests) {
    var n = test[0]
    var b = test[1]
    var sum = sumDigits.call(n, b)
    System.print("%(Fmt.s(-5, Conv.itoa(n, b))) in base %(Fmt.d(2, b)) = %(Fmt.d(2, sum))")
}
