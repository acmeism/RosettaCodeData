import "/math" for Int

var sameDigits = Fn.new { |n, b|
    var f = n % b
    n = (n/b).floor
    while (n > 0) {
        if (n%b != f) return false
        n = (n/b).floor
    }
    return true
}

var isBrazilian = Fn.new { |n|
    if (n < 7) return false
    if (n%2 == 0 && n >= 8) return true
    for (b in 2...n-1) {
        if (sameDigits.call(n, b)) return true
    }
    return false
}

for (kind in [" ", " odd ", " prime "]) {
    System.print("First 20%(kind)Brazilian numbers:")
    var c = 0
    var n = 7
    while (true) {
        if (isBrazilian.call(n)) {
            System.write("%(n) ")
            c = c + 1
            if (c == 20) {
                System.print("\n")
                break
            }
        }
        if (kind == " ") {
            n = n + 1
        } else if (kind == " odd ") {
            n = n + 2
        } else {
            while (true) {
                n = n + 2
                if (Int.isPrime(n)) break
            }
        }
    }
}

var c = 0
var n = 7
while (c < 1e5) {
    if (isBrazilian.call(n)) c = c + 1
    n = n + 1
}
System.print("The 100,000th Brazilian number: %(n-1)")
