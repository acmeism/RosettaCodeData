var expDigitSums = Fn.new { |numNeeded, minWays, maxPower|
    var i = Mpz.one
    var c = 0
    var n = Mpz.new()
    while (c < numNeeded) {
        i.inc
        n.set(i)
        var res = []
        for (p in 2..maxPower) {
            n.mul(i)
            var ds = digitSum.call(n)
            if (i == ds) {
                res.add("%(i)^%(p)")
            }
            if (p > 10 && i * 2 < ds) break  // added this line
        }
        if (res.count >= minWays) {
            System.print(res.join(", "))
            c = c + 1
        }
    }
}
