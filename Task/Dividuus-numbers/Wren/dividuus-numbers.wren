import "./math" for Int, Nums
import "./fmt" for Fmt

var mult = Fn.new { |n|
    var m = 1
    while (m > 0 && n > 0) {
        var dm = n % 10
        m = m * dm
        n = (n / 10).floor
    }
    return m
}

var multDigRoot = Fn.new { |n|
    var m = n
    while (m >= 10) m = mult.call(m)
    return m
}

var isDividuus = Fn.new { |n|
    var digits = Int.digits(n)
    if (digits.contains(0)) return false
    var sumDigits = Nums.sum(digits)
    if (n % sumDigits != 0) return false
    var prodDigits = Nums.prod(digits)
    if (n % prodDigits != 0) return false
    var digRoot = Int.digitalRoot(n)[0]
    if (n % digRoot != 0) return false
    var mdr = multDigRoot.call(n)
    return n % mdr == 0
}

System.print("First fifty Dividuus numbers:")
var i = 1
var divs = []
while (divs.count < 50) {
    if (isDividuus.call(i)) divs.add(i)
    i = i + 1
}
Fmt.tprint("$5d", divs, 10)

divs.clear()
System.print("\nDividuus numbers between 990,000,000 and 1,000,000,000:")
for (i in 990000000...1000000000) {
    if (isDividuus.call(i)) divs.add(i)
}
Fmt.tprint("$,11d ", divs, 5)
