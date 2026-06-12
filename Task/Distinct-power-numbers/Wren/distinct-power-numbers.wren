import "./seq" for Lst
import "./fmt" for Fmt

var pows = []
for (a in 2..5) {
    var pow = a
    for (b in 2..5) {
        pow = pow * a
        pows.add(pow)
    }
}
pows = Lst.distinct(pows).sort()
System.print("Ordered distinct values of a ^ b for a in [2..5] and b in [2..5]:")
Fmt.tprint("$,5d", pows, 5)
System.print("\nFound %(pows.count) such numbers.")
