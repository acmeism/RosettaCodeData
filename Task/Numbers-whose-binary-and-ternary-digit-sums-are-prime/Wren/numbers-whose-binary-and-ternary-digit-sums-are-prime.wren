import "./math" for Int
import "./fmt" for Fmt

var numbers = []
for (i in 2..199) {
    var bds = Int.digitSum(i, 2)
    if (Int.isPrime(bds)) {
        var tds = Int.digitSum(i, 3)
        if (Int.isPrime(tds)) numbers.add(i)
    }
}
System.print("Numbers < 200 whose binary and ternary digit sums are prime:")
Fmt.tprint("$4d", numbers, 14)
System.print("\nFound %(numbers.count) such numbers.")
