var gcd = Fn.new { |x, y|
    while (y != 0) {
        var t = y
        y = x % y
        x = t
    }
    return x.abs
}

System.print("gcd(33, 77) = %(gcd.call(33, 77))")
System.print("gcd(49865, 69811) = %(gcd.call(49865, 69811))")
