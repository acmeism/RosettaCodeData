import "./math" for Int

System.print("The first 20 anti-primes are:")
var maxDiv = 0
var count = 0
var n = 1
while (count < 20) {
    var d = Int.divisors(n).count
    if (d > maxDiv) {
       System.write("%(n) ")
       maxDiv = d
       count = count + 1
    }
    n = n + 1
}
System.print()
