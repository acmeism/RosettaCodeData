import "./math" for Int

// cache 5th powers of digits
var dp5 = (0..9).map { |d| d.pow(5) }.toList

System.print("The sum of all numbers that can be written as the sum of the 5th powers of their digits is:")
var limit = dp5[9] * 6
var sum = 0
for (i in 2..limit) {
    var digits = Int.digits(i)
    var totalDp = digits.reduce(0) { |acc, d| acc + dp5[d] }
    if (totalDp == i) {
        System.write((sum > 0) ? " + %(i)" : i)
        sum = sum + i
    }
}
System.print(" = %(sum)")
