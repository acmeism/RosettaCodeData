import "./math" for Int
import "./rat" for Rat

System.print("The following numbers (less than 2^19) are perfect:")
for (i in 2...(1<<19)) {
    var sum = Rat.new(1, i)
    for (j in Int.properDivisors(i)[1..-1]) sum = sum + Rat.new(1, j)
    if (sum == Rat.one) System.print("  %(i)")
}
