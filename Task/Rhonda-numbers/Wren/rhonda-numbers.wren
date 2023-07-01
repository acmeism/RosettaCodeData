import "./math" for Math, Int, Nums
import "./fmt" for Fmt, Conv

for (b in 2..36) {
    if (Int.isPrime(b)) continue
    var count = 0
    var rhonda = []
    var n = 1
    while (count < 15) {
        var digits = Int.digits(n, b)
        if (!digits.contains(0)) {
            if (b != 10 || (digits.contains(5) && digits.any { |d| d % 2 == 0 })) {
                var calc1 = Nums.prod(digits)
                var calc2 = b * Nums.sum(Int.primeFactors(n))
                if (calc1 == calc2) {
                    rhonda.add(n)
                    count = count + 1
                }
            }
        }
        n = n + 1
    }
    if (rhonda.count > 0) {
        System.print("\nFirst 15 Rhonda numbers in base %(b):")
        var rhonda2 = rhonda.map { |r| r.toString }.toList
        var rhonda3 = rhonda.map { |r| Conv.Itoa(r, b) }.toList
        var maxLen2 = Nums.max(rhonda2.map { |r| r.count })
        var maxLen3 = Nums.max(rhonda3.map { |r| r.count })
        var maxLen  = Math.max(maxLen2, maxLen3) + 1
        Fmt.print("In base 10:  $*s", maxLen, rhonda2)
        Fmt.print("In base $-2d:  $*s", b, maxLen, rhonda3)
    }
}
