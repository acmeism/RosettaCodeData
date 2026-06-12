import "./math" for Int
import "./fmt" for Fmt

var isHappy = Fn.new { |n|
    var prev = {}
    while (true) {
        var digits = Int.digits(n)
        var sumSq = digits.reduce(0) { |acc, x| acc + x * x }
        if (sumSq == 1) return true
        if (prev[sumSq]) return false
        prev[n = sumSq] = true
    }
}

var hp = []
var n = 1
while (hp.count < 50) {
    if (isHappy.call(n) && Int.isPrime(n)) {
        hp.add(n)
        if (hp.count == 50) {
            System.print("The first 50 happy primes are:")
            Fmt.tprint("$4d ", hp, 10)
        }
    }
    n = n + 1
}

System.print("\nPrime\nfraction  Index  Value")
var hnc = 0
var hpc = 0
n = 1
var r = 2
while (r <= 15) {
    if (isHappy.call(n)) {
        hnc = hnc + 1
        if (Int.isPrime(n)) hpc = hpc + 1
        if (hnc > 1 && hpc / hnc <= 1 / r) {
            Fmt.print("1 / $-2d:  $6d  $-7d", r, hnc, n)
            r = r + 1
        }
    }
    n = n + 1
}
