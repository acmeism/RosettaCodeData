import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(5 * 1e6)
var i = 1
var count = 0
var h = []
var h10000
while (true) {
    if (Int.digitSum(i) == Int.digitSum(primes[i-1])) {
        count = count + 1
        if (count <= 50) {
            h.add([i, primes[i-1]])
        } else  if (count == 10000) {
            h10000 = [i, primes[i-1]]
            break
        }
    }
    i = i + 1
}
System.print("The first 50 Honaker primes (index, prime):")
for (i in 0..49) {
    Fmt.write("($3d, $,5d) ", h[i][0], h[i][1])
    if ((i + 1) % 5 == 0) System.print()
}
Fmt.print("\nand the 10,000th: ($,7d, $,9d)", h10000[0], h10000[1])
