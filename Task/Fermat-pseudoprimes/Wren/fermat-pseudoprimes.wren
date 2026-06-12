import "./math" for Int
import "./gmp" for Mpz
import "./fmt" for Fmt

var one = Mpz.one

var isFermatPseudoprime = Fn.new { |x, a|
    if (Int.isPrime(x)) return false
    var bx = Mpz.from(x)
    a = Mpz.from(a)
    return a.modPow(x-1, bx) == one
}

System.print("First 20 Fermat pseudoprimes:")
for (a in 1..20) {
    var count = 0
    var x = 2
    var first20 = List.filled(20, 0)
    while (count < 20) {
        if (isFermatPseudoprime.call(x, a)) {
            first20[count] = x
            count = count + 1
        }
        x = x + 1
    }
    Fmt.print("Base $2d: $5d", a, first20)
}
var limits = [12000, 25000, 50000, 100000]
var heading = Fmt.swrite("\nCount <= $6d", limits)
System.print(heading)
System.print("-" * (heading.count - 1))
for (a in 1..20) {
    Fmt.write("Base $2d: ", a)
    var x = 2
    var count = 0
    for (limit in limits) {
        while (x <= limit) {
            if (isFermatPseudoprime.call(x, a)) count = count + 1
            x = x + 1
        }
        Fmt.write("$6d ", count)
    }
    System.print()
}
