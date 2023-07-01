import "./math" for Math, Int
import "./rat" for Rat

var giuga = Fn.new { |n|
    System.print("n = %(n):")
    var p = List.filled(n, 0)
    var s = List.filled(n, null)
    for (i in 0..n-2) s[i] = Rat.zero
    p[2] = 2
    p[1] = 2
    var t = 2
    s[1] = Rat.half
    while (t > 1) {
        p[t] = Int.isPrime(p[t] + 1) ? p[t] + 1 : Int.nextPrime(p[t] + 1)
        s[t] = s[t-1] + Rat.new(1, p[t])
        if (s[t] == Rat.one || s[t] + Rat.new(n - t, p[t]) <= Rat.one) {
            t = t - 1
        } else if (t < n - 2) {
            t = t + 1
            p[t] = Math.max(p[t-1], (s[t-1] / (Rat.one - s[t-1])).toFloat).floor
        } else {
            var c = s[n-2].num
            var d = s[n-2].den
            var k = d * d + c - d
            var f = Int.divisors(k)
            for (i in 0...((f.count + 1)/2).floor) {
                var h = f[i]
                if ((h + d) % (d-c) == 0 && (k/h + d) % (d - c) == 0) {
                    var r1 = (h + d) / (d - c)
                    var r2 = (k/h + d) / (d - c)
                    if (r1 > p[n-2] && r2 > p[n-2] && r1 != r2 && Int.isPrime(r1) && Int.isPrime(r2)) {
                        var w = d * r1 * r2
                        System.print(w)
                    }
                }
            }
        }
    }
}

for (n in 3..6) {
    giuga.call(n)
    System.print()
}
