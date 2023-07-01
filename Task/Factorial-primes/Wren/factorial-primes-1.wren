import "./math" for Int
import "./fmt" for Fmt

System.print("First 10 factorial primes;")
var c = 0
var i = 1
var f = 1
while (true) {
    for (gs in [[f-1, "-"], [f+1, "+"]]) {
        if (Int.isPrime(gs[0])) {
            Fmt.print("$2d: $2d! $s 1 = $d", c = c + 1, i, gs[1], gs[0])
            if (c == 10) return
        }
    }
    i = i + 1
    f = f * i
}
