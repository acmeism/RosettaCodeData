import "./math" for Int
import "./iterate" for Stepped
import "./fmt" for Fmt

var limit = 200
for (n in Stepped.new(1...limit, 2)) {
    var p = n*n*n + 2
    if (Int.isPrime(p)) Fmt.print("n = $3d => n³ + 2 = $,9d", n, p)
}
