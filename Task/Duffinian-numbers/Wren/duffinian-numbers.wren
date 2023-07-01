import "./math" for Int
import "./seq" for Lst
import "./fmt" for Fmt

var limit = 200000  // say
var d = Int.primeSieve(limit-1, false)
d[1] = false
for (i in 2...limit) {
    if (!d[i]) continue
    if (i % 2 == 0 && !Int.isSquare(i) && !Int.isSquare(i/2)) {
        d[i] = false
        continue
    }
    var sigmaSum = Int.divisorSum(i)
    if (Int.gcd(sigmaSum, i) != 1) d[i] = false
}

var duff = (1...d.count).where { |i| d[i] }.toList
System.print("First 50 Duffinian numbers:")
Fmt.tprint("$3d", duff[0..49], 10)

var triplets = []
for (i in 2...limit) {
    if (d[i] && d[i-1] && d[i-2]) triplets.add([i-2, i-1, i])
}
System.print("\nFirst 50 Duffinian triplets:")
Fmt.tprint("$-25n", triplets[0..49], 4)
