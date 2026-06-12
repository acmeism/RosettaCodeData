import "./math" for Int
import "./gmp" for Mpz
import "./fmt" for Fmt

var one = Mpz.one

var isSuperPoulet = Fn.new { |x|
    if (Int.isPrime(x)) return false
    var bx = Mpz.from(x)
    if (Mpz.two.modPow(x-1, bx) != one) return false
    var t = Mpz.new()
    return Int.divisors(x).skip(1).all { |d| t.uiPow(2, d).sub(2).isDivisibleUi(d) }
}

var count = 0
var first20 = List.filled(20, 0)
var x = 3
while (count < 20) {
    if (isSuperPoulet.call(x)) {
        first20[count] = x
        count = count + 1
    }
    x = x + 2  // Poulet numbers are always odd
}
System.print("The first 20 super-Poulet numbers are:")
System.print(first20)
System.print()
var limit = 1e6
while (true) {
   if (isSuperPoulet.call(x)) {
        count = count + 1
        if (x > limit) {
            Fmt.print("The $r super-Poulet number and the first over $,d is $,d.", count, limit, x)
            if (limit == 1e6) limit = 1e7 else return
        }
   }
   x = x + 2
}
