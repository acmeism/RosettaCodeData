import "./math" for Int
import "./fmt" for Fmt

var isCurzon = Fn.new { |n, k|
    var r = k * n
    return Int.modPow(k, n, r+1) == r
}

var k = 2
while (k <= 10) {
    System.print("Curzon numbers with base %(k):")
    var n = 1
    var count = 0
    while (count < 50) {
        if (isCurzon.call(n, k)) {
            Fmt.write("$4d ", n)
            count = count + 1
            if (count % 10 == 0) System.print()
        }
        n = n + 1
    }
    while (true) {
        if (isCurzon.call(n, k)) count = count + 1
        if (count == 1000) break
        n = n + 1
    }
    Fmt.print("1,000th Curzon number with base $d: $,d\n", k, n)
    k = k + 2
}
