import "./math" for Int
import "./fmt" for Fmt

var p = Int.primeSieve(1000)
System.print("Double twin primes under 1,000:")
for (i in 1...p.count-3) {
    if (p[i+1] - p[i] == 2 && p[i+2] - p[i+1] == 4 && p[i+3] - p[i+2] == 2) {
        Fmt.aprint(p[i..i+3], 4, 0, "")
    }
}
