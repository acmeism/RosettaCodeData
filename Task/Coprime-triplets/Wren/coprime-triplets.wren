import "./math" for Int
import "./fmt" for Fmt

var limit = 50
var cpt = [1, 2]

while (true) {
    var m = 1
    while (cpt.contains(m) || Int.gcd(m, cpt[-1]) != 1 || Int.gcd(m, cpt[-2]) != 1) {
        m = m + 1
    }
    if (m >= limit) break
    cpt.add(m)
}
System.print("Coprime triplets under %(limit):")
Fmt.tprint("$2d", cpt, 10)
System.print("\nFound %(cpt.count) such numbers.")
