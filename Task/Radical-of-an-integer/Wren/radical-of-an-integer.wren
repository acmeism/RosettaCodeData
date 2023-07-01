import "./math" for Int, Nums
import "./seq" for Lst
import "./fmt" for Fmt

var radicals = List.filled(51, 0)
radicals[1] = 1
var counts = List.filled(8, 0)
counts[1] = 1
for (i in 2..1e6) {
    var factors = Lst.prune(Int.primeFactors(i))
    var fc = factors.count
    counts[fc] = counts[fc] + 1
    if (i <= 50) radicals[i] = Nums.prod(factors)
    if (i == 50) {
        System.print("The radicals for the first 50 positive integers are:")
        Fmt.tprint("$2d ", radicals.skip(1), 10)
        System.print()
    } else if (i == 99999 || i == 499999 || i == 999999) {
        Fmt.print("Radical for $,7d: $,7d", i, Nums.prod(factors))
    } else if (i == 1e6) {
        System.print("\nBreakdown of numbers of distinct prime factors")
        System.print("for positive integers from 1 to 1,000,000:")
        for (i in 1..7) {
            Fmt.print("  $d: $,8d", i, counts[i])
        }
        Fmt.print("    ---------")
        Fmt.print("    $,8d", Nums.sum(counts))
        Fmt.print("\nor graphically:")
        Nums.barChart("", 50, Nums.toStrings(1..7), counts[1..-1])
    }
}
var pcount = Int.primeCount(1e6)
var ppcount = 0
var primes1k = Int.primeSieve(1000)
for (p in primes1k) {
    var p2 = p
    while (true) {
        p2 = p2 * p
        if (p2 > 1e6) break
        ppcount = ppcount + 1
    }
}
Fmt.print("\nFor primes or powers (>1) thereof <= 1,000,000:")
Fmt.print("  Number of primes   = $,6d", pcount)
Fmt.print("  Number of powers   = $,6d", ppcount)
Fmt.print("  Add 1 for number 1 = $,6d", 1)
Fmt.print("                       ------")
Fmt.print("                       $,6d", pcount + ppcount + 1)
