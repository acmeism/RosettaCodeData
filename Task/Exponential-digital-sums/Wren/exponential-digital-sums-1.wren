import "./gmp" for Mpz

var digitSum = Fn.new { |bi|
    var sum = 0
    for (d in bi.toString.bytes) {
        sum = sum + d - 48
    }
    return sum
}

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
        }
        if (res.count >= minWays) {
            System.print(res.join(", "))
            c = c + 1
        }
    }
}

System.print("First twenty-five integers that are equal to the digital sum of that integer raised to some power:")
expDigitSums.call(25, 1, 100)

System.print("\nFirst thirty that satisfy that condition in three or more ways:")
expDigitSums.call(30, 3, 500)
