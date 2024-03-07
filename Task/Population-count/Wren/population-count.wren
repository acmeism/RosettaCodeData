import "./big" for BigInt
import "./fmt" for Fmt

var popCount = Fn.new { |n|
    var count = 0
    while (n != 0) {
        n = n & (n - 1)
        count = count + 1
    }
    return count
}

System.print("The population count of the first 30 powers of 3 is:")
var p3 = 1
for (i in 0..29) {
    System.write("%(popCount.call(p3)) ")
    p3 = p3 * 3
    if (i == 20) p3 = BigInt.new(p3)
}
var odious = []
System.print("\n\nThe first 30 evil numbers are:")
var count = 0
var n = 0
while (count < 30) {
    var pc = popCount.call(n)
    if (pc%2 == 0) {
        System.write("%(n) ")
        count = count + 1
    } else {
        odious.add(n)
    }
    n = n + 1
}
odious.add(n)
System.print("\n\nThe first 30 odious numbers are:")
Fmt.print("$d", odious)
