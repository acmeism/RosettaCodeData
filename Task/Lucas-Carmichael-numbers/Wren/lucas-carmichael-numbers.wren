import "./psieve" for Primes
import "./math" for Int, Nums
import "./big" for BigInt
import "./fmt" for Fmt

var lucasCarmichael = Fn.new { |A, B, k|
    var LC = []
    var maxP = (B+1).sqrt.floor - 1
    var p = Primes.nthAfter(k+1, 1)
    var primes = Primes.between(2, p)
    var x = (Nums.prod(primes)/2).floor
    A = A.max(x)
    var M = 1
    var P = 1
    var F
    F = Fn.new { |m, L, lo, k|
        var hi = (B/m).floor.pow(1/k).round
        if (lo > hi) return []
        if (k == 1) {
            hi = hi.min(maxP)
            lo = lo.max((A/m).ceil).round
            if (lo > hi) return []
            var t
            if (m <= Num.maxSafeInteger) {
                t = L - Int.modInv(m, L)
            } else {
                var bm = BigInt.new(M) * P
                t = L - bm.modInv(L).toNum
            }
            if (t > hi) return []
            while (t < lo) t = t + L
            p = t
            while (p <= hi) {
                if (Int.isPrime(p)) {
                    var n = m * p
                    if (n + 1 <= Num.maxSafeInteger) {
                        if ((n+1) % (p+1) == 0) LC.add(n)
                    } else {
                        var bn = BigInt.new(M) * P * p
                        if ((bn+1) % (p+1) == 0) LC.add(bn)
                    }
                }
                p = p + L
            }
            return []
        }
        for (p in Primes.between(lo, hi)) {
            if (Int.gcd(m, p+1) == 1) {
                M = m
                P = p
                F.call(m*p, Int.lcm(L, p+1), p+1, k-1)
            }
        }
    }
    F.call(1, 1, 3, k)
    if (LC.any { |e| e is BigInt }) {
        for (i in 0...LC.count) {
            if (LC[i] is Num) LC[i] = BigInt.new(LC[i])
        }
    }
    return LC.sort()
}

var lcWithNPrimes = Fn.new { |n|
    if (n < 3) return []
    var p = Primes.nthAfter(n+1, 1)
    var primes = Primes.between(2, p)
    var x = (Nums.prod(primes)/2).floor
    var y = 2 * x
    while (true) {
        var LC = lucasCarmichael.call(x, y, n)
        if (LC.count >= 1) return LC[0]
        x = y + 1
        y = 2 * x
    }
}

var lcCount = Fn.new { |A, B|
    var count = 0
    for (k in 3..1e6) {
        var p = Primes.nthAfter(k+1, 1)
        var primes = Primes.between(2, p)
        var x = (Nums.prod(primes)/2).floor
        if (x > B) break
        count = count + lucasCarmichael.call(A, B, k).count
    }
    return count
}

System.print("Least Lucas-Carmichael number with n prime factors:")
for (n in 3..12) {
    Fmt.print("$2d: $i", n, lcWithNPrimes.call(n))
}

System.print("\nNumber of Lucas-Carmichael numbers less than 10^n:")
for (n in 1..10) {
    Fmt.print("$2d: $d", n, lcCount.call(1, 10.pow(n)))
}
