import "./fmt" for Conv, Fmt
import "./set" for Set

var limit = 1e5
var count = 0
System.print("Numbers under 100,000 which use the same digits in decimal or hex:")
for (n in 0...limit) {
    var h = Conv.hex(n)
    var hs = Set.new(h)
    var ns = Set.new(n.toString)
    if (hs == ns) {
        count = count + 1
        Fmt.write("$,6d ", n)
        if (count % 10 == 0) System.print()
    }
}
System.print("\n\n%(count) such numbers found.")
