import "./math" for Int
import "./fmt" for Fmt

var prods = List.filled(100, 0)
prods[0] = 1
for (i in 2..100) {
    var factors = Int.primeFactors(i)
    prods[i-1] = factors[0] * factors[-1]
}
System.print("Product of smallest and greatest prime factors of n for 1 to 100:")
Fmt.tprint("$4d", prods, 10)
