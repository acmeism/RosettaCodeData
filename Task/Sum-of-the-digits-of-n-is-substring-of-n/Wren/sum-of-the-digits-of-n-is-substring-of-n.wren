import "./math" for Int
import "./fmt" for Fmt

var numbers = []
for (n in 0..999) {
    var ns = n.toString
    var ds = Int.digitSum(n).toString
    if (ns.contains(ds)) numbers.add(n)
}
System.print("Numbers under 1,000 whose sum of digits is a substring of themselves:")
Fmt.tprint("$3d", numbers, 8)
System.print("\n%(numbers.count) such numbers found.")
