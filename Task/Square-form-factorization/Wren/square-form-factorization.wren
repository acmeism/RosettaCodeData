import "/long" for ULong
import "/big" for BigInt
import "/fmt" for Fmt

var multipliers = [
    1, 3, 5, 7, 11, 3*5, 3*7, 3*11, 5*7, 5*11, 7*11, 3*5*7, 3*5*11, 3*7*11, 5*7*11, 3*5*7*11
]

var squfof = Fn.new { |N|
    var s = ULong.new((N.toNum.sqrt + 0.5).floor)
    if (s*s == N) return s
    for (multiplier in multipliers) {
        var T = ULong
        var n = N
        if (n > ULong.largest/multiplier) {
            T = BigInt
            n = BigInt.new(n.toString)
        }
        var D = n * multiplier
        var P = D.isqrt
        var Pprev = P
        var Po = Pprev
        var Qprev = T.one
        var Q = D - Po*Po
        var L = (s * 8).isqrt.toSmall
        var B = 3 * L
        var i = 2
        var b = T.zero
        var q = T.zero
        var r = T.zero
        while (i < B) {
            b = (Po + P) / Q
            P = b * Q - P
            q = Q
            Q = Qprev + b * (Pprev - P)
            r = T.new((Q.toNum.sqrt + 0.5).floor)
            if ((i & 1) == 0 && r*r == Q) break
            Qprev = q
            Pprev = P
            i = i + 1
        }
        if (i < B) {
            b = (Po - P) / r
            Pprev = P = b*r + P
            Qprev = r
            Q = (D - Pprev*Pprev) / Qprev
            i = 0
            while (true) {
                b = (Po + P) / Q
                Pprev = P
                P = b * Q - P
                q = Q
                Q = Qprev + b * (Pprev - P)
                Qprev = q
                i = i + 1
                if (P == Pprev) break
            }
            r = T.gcd(n, Qprev)
            if (r != T.one && r != n) return (r is ULong) ? r : ULong.new(r.toString)
        }
    }
    return ULong.zero
}

var examples = [
    "2501",
    "12851",
    "13289",
    "75301",
    "120787",
    "967009",
    "997417",
    "7091569",
    "13290059",
    "42854447",
    "223553581",
    "2027651281",
    "11111111111",
    "100895598169",
    "1002742628021",
    "60012462237239",
    "287129523414791",
    "9007199254740931",
    "11111111111111111",
    "314159265358979323",
    "384307168202281507",
    "419244183493398773",
    "658812288346769681",
    "922337203685477563",
    "1000000000000000127",
    "1152921505680588799",
    "1537228672809128917",
    "4611686018427387877"
]

System.print("Integer              Factor     Quotient")
System.print("------------------------------------------")
for (example in examples) {
    var N = ULong.new(example)
    var fact = squfof.call(N)
    var quot = (fact.isZero) ? "fail" : (N / fact).toString
    Fmt.print("$-20s $-10s $s", N, fact, quot)
}
