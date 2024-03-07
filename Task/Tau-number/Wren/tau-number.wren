import "./math" for Int
import "./fmt" for Fmt

System.print("The first 100 tau numbers are:")
var count = 0
var i = 1
while (count < 100) {
    var tf = Int.divisors(i).count
    if (i % tf == 0) {
        Fmt.write("$,5d  ", i)
        count = count + 1
        if (count % 10 == 0) System.print()
    }
    i = i + 1
}
