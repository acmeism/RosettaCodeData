import "./fmt" for Fmt
import "./math" for Int, Nums

var chowla = Fn.new { |n| (n > 1) ? Nums.sum(Int.properDivisors(n)) - 1 : 0 }

for (i in 1..37) Fmt.print("chowla($2d) = $d", i, chowla.call(i))
System.print()
var count = 1
var limit = 1e7
var c = Int.primeSieve(limit, false)
var power = 100
var i = 3
while (i < limit) {
    if (!c[i]) count = count + 1
    if (i == power - 1) {
        Fmt.print("Count of primes up to $,-10d = $,d", power, count)
        power = power * 10
    }
    i = i + 2
}
System.print()
count = 0
limit = 35 * 1e6
i = 2
while (true) {
    var p = (1 << (i -1)) * ((1<<i) - 1) // perfect numbers must be of this form
    if (p > limit) break
    if (chowla.call(p) == p-1) {
        Fmt.print("$,d is a perfect number", p)
        count = count + 1
    }
    i = i + 1
}
System.print("There are %(count) perfect numbers <= 35,000,000")
