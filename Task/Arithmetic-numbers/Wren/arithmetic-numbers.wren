import "./math" for Int, Nums
import "./fmt" for Fmt
import "./sort" for Find

var arithmetic = [1]
var primes = []
var limit = 1e6
var n = 3
while (arithmetic.count < limit) {
    var divs = Int.divisors(n)
    if (divs.count == 2) {
        primes.add(n)
        arithmetic.add(n)
    } else {
        var mean = Nums.mean(divs)
        if (mean.isInteger) arithmetic.add(n)
    }
    n = n + 1
}
System.print("The first 100 arithmetic numbers are:")
Fmt.tprint("$3d", arithmetic[0..99], 10)

for (x in [1e3, 1e4, 1e5, 1e6]) {
    var last = arithmetic[x-1]
    Fmt.print("\nThe $,dth arithmetic number is: $,d", x, last)
    var pcount = Find.nearest(primes, last) + 1
    if (!Int.isPrime(last)) pcount = pcount - 1
    var comp = x - pcount - 1 // 1 is not composite
    Fmt.print("The count of such numbers <= $,d which are composite is $,d.", last, comp)
}
