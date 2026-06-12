import "./big" for BigInt
import "./fmt" for Fmt

System.print(" n  smallest power of 6 which contains n")
var six = BigInt.new(6)
for (n in 0..21) {
    var i = 0
    while (true) {
        var pow6 = six.pow(i).toString
        if (pow6.contains(n.toString)) {
            Fmt.print("$2d  6^$-2d = $,s", n, i, pow6)
            break
        }
        i = i + 1
    }
}
