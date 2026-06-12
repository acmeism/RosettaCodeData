import "./math" for Int
import "./fmt" for Fmt

var strToDec = Fn.new { |s, b|
    var res =  0
    for (c in s) {
        var d = Num.fromString(c)
        res = res * b + d
    }
    return res
}

var limit = 2500
var pbnp = []
for (n in 3..limit) {
    if (n % 10 == 0 && n > 10) {
        pbnp.add(n)
    } else if (n > 9 && Int.gcd(Int.digits(n)) > 1) {
        pbnp.add(n)
    } else {
        var comp = true
        for (b in 2...n) {
            var d = strToDec.call(n.toString, b)
            if (Int.isPrime(d)) {
                comp = false
                break
            }
        }
        if (comp) pbnp.add(n)
    }
}

System.print("First 50 pan-base composites:")
Fmt.tprint("$3d", pbnp[0..49], 10)

System.print("\nFirst 20 odd pan-base composites:")
var odd = pbnp.where { |n| n % 2 == 1 }.toList
Fmt.tprint("$3d", odd[0..19], 10)

var tc
System.print("\nCount of pan-base composites up to and including %(limit): %(tc = pbnp.count)")
var c
Fmt.print("Number odd  = $3d or $9.6f\%", c = odd.count, c/tc * 100)
Fmt.print("Number even = $3d or $9.6f\%", c = tc - c, c/tc * 100)
