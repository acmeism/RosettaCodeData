import "./math" for Int
import "./fmt" for Fmt

var inc = [4, 2, 4, 2, 4, 6, 2, 6]

// Assumes n is odd.
var firstPrimeFactor = Fn.new { |n|
    if (n == 1) return 1
    if (n%3 == 0) return 3
    if (n%5 == 0) return 5
    var k = 7
    var i = 0
    while (k * k <= n) {
        if (n%k == 0)  {
            return k
        } else {
            k = k + inc[i]
            i = (i + 1) % 8
        }
    }
    return n
}

var blum = List.filled(50, 0)
var bc = 0
var counts = { 1: 0, 3: 0, 7: 0, 9: 0 }
var i = 1
while (true) {
    var p = firstPrimeFactor.call(i)
    if (p % 4 == 3) {
        var q = i / p
        if (q != p && q % 4 == 3 && Int.isPrime(q)) {
            if (bc < 50) blum[bc] = i
            counts[i % 10] = counts[i % 10] + 1
            bc = bc + 1
            if (bc == 50) {
                System.print("First 50 Blum integers:")
                Fmt.tprint("$3d ", blum, 10)
                System.print()
            } else if (bc == 26828 || bc % 1e5 == 0) {
                Fmt.print("The $,9r Blum integer is: $,9d", bc, i)
                if (bc == 400000) {
                    System.print("\n\% distribution of the first 400,000 Blum integers:")
                    for (i in [1, 3, 7, 9]) {
                        Fmt.print("  $6.3f\% end in $d", counts[i]/4000, i)
                    }
                    return
                }
            }
        }
    }
    i = (i % 5 == 3) ? i + 4 : i + 2
}
