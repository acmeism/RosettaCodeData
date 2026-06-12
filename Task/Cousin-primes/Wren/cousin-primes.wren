import "./math" for Int
import "./fmt" for Fmt

var c = Int.primeSieve(999, false)
var count = 0
System.print("Cousin prime pairs whose elements are less than 1,000:")
var i = 3
while (i <= 995) {
    if (!c[i] && !c[i + 4]) {
        Fmt.write("$3d:$3d  ", i, i + 4)
        count = count + 1
        if ((count % 7) == 0) System.print()
        i = (i != 3) ? i + 4 : i + 2
    }
    i = i + 2
}
System.print("\n\n%(count) pairs found")
