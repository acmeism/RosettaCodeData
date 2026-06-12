import "./math" for Int
import "./fmt" for Fmt

// Maximum ratio for 6 digit numbers is 100,000
var cons = List.filled(100001, false)
for (i in 1..999999) {
    var ds = Int.digitSum(i)
    var ids = i/ds
    if (ids.isInteger) cons[ids] = true
}
var incons = []
for (i in 1...cons.count) {
    if (!cons[i]) incons.add(i)
}
System.print("First 50 inconsummate numbers in base 10:")
Fmt.tprint("$3d", incons[0..49], 10)
Fmt.print("\nOne thousandth: $,d", incons[999])
