import "./big" for BigInt
import "./fmt" for Fmt

var res = []
for (n in 0..50) {
    var k = 1
    while (true) {
        var s = BigInt.new(k).pow(k).toString
        if (s.contains(n.toString)) {
            res.add(k)
            break
        }
        k = k + 1
    }
}
System.print("The smallest positive integers K where K ^ K contains N (0..50) are:")
Fmt.tprint("$2d", res, 17)
