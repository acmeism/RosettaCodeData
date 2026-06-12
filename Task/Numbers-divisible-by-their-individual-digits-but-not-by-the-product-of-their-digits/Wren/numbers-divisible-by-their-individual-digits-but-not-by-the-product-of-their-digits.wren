import "./math" for Int, Nums
import "./fmt" for Fmt

var res = []
for (n in 1..999) {
    var digits = Int.digits(n)
    if (digits.all { |d| n % d == 0 }) {
        var prod = Nums.prod(digits)
        if (prod > 0 && n % prod != 0) res.add(n)
    }
}
System.print("Numbers < 1000 divisible by their digits, but not by the product thereof:")
Fmt.tprint("$4d", res, 9)
System.print("\n%(res.count) such numbers found")
