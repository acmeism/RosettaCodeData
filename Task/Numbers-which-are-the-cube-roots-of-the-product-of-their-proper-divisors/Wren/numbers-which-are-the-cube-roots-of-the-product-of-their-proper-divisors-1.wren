import "./math" for Int, Nums
import "./long" for ULong, ULongs
import "./fmt" for Fmt

var numbers50 = []
var count = 0
var n = 1
var ln
var maxSafe = Num.maxSafeInteger.cbrt.floor
System.print("First 50 numbers which are the cube roots of the products of their proper divisors:")
while (true) {
    var pd = Int.properDivisors(n)
    if ((n <= maxSafe && Nums.prod(pd) == n * n * n) ||
        (ULongs.prod(pd.map { |f| ULong.new(f) }) == (ln = ULong.new(n)) * ln * ln )) {
        count = count + 1
        if (count <= 50) {
            numbers50.add(n)
            if (count == 50) Fmt.tprint("$3d", numbers50, 10)
        } else if (count == 500) {
            Fmt.print("\n500th   : $,d", n)
        } else if (count == 5000) {
            Fmt.print("5,000th : $,d", n)
        } else if (count == 50000) {
            Fmt.print("50,000th: $,d", n)
            break
        }
    }
    n = n + 1
}
