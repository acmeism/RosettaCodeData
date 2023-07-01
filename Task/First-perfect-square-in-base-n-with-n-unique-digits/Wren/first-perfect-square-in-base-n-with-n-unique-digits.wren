import "/big" for BigInt
import "/math" for Nums
import "/fmt" for Conv, Fmt

var maxBase  = 21
var minSq36  = "1023456789abcdefghijklmnopqrstuvwxyz"
var minSq36x = "10123456789abcdefghijklmnopqrstuvwxyz"

var containsAll = Fn.new { |sq, base|
    var found = List.filled(maxBase, 0)
    var le = sq.count
    var reps = 0
    for (r in sq) {
        var d = r.bytes[0] - 48
        if (d > 38) d = d - 39
        found[d] = found[d] + 1
        if (found[d] > 1) {
            reps = reps + 1
            if (le - reps < base) return false
        }
    }
    return true
}

var sumDigits = Fn.new { |n, base|
    var sum = BigInt.zero
    while (n > 0) {
        sum = sum + (n%base)
        n = n/base
    }
    return sum
}

var digitalRoot = Fn.new { |n, base|
    while (n > base - 1) n = sumDigits.call(n, base)
    return n.toSmall
}

var minStart = Fn.new { |base|
    var ms = minSq36[0...base]
    var nn = BigInt.fromBaseString(ms, base)
    var bdr = digitalRoot.call(nn, base)
    var drs = []
    var ixs = []
    for (n in 1...2*base) {
        nn = BigInt.new(n*n)
        var dr = digitalRoot.call(nn, base)
        if (dr == 0) dr = n * n
        if (dr == bdr) ixs.add(n)
        if (n < base && dr >= bdr) drs.add(dr)
    }
    var inc = 1
    if (ixs.count >= 2 && base != 3) inc = ixs[1] - ixs[0]
    if (drs.count == 0) return [ms, inc, bdr]
    var min = Nums.min(drs)
    var rd = min - bdr
    if (rd == 0) return [ms, inc, bdr]
    if (rd == 1) return [minSq36x[0..base], 1, bdr]
    var ins = minSq36[rd]
    return [(minSq36[0...rd] + ins + minSq36[rd..-1])[0..base], inc, bdr]
}

var start = System.clock
var n = 2
var k = 1
var base = 2
while (true) {
    if (base == 2 || (n % base) != 0) {
        var nb = BigInt.new(n)
        var sq = nb.square.toBaseString(base)
        if (containsAll.call(sq, base)) {
            var ns = Conv.itoa(n, base)
            var tt = System.clock - start
            Fmt.print("Base $2d:$15s² = $-27s in $8.3fs", base, ns, sq, tt)
            if (base == maxBase) break
            base = base + 1
            var res = minStart.call(base)
            var ms = res[0]
            var inc = res[1]
            var bdr = res[2]
            k = inc
            var nn = BigInt.fromBaseString(ms, base)
            nb = nn.isqrt
            if (nb < n + 1) nb = BigInt.new(n+1)
            if (k != 1) {
                while (true) {
                    nn = nb.square
                    var dr = digitalRoot.call(nn, base)
                    if (dr == bdr) {
                        n = nb.toSmall - k
                        break
                    }
                    nb = nb.inc
                }
            } else {
                n = nb.toSmall - k
            }
        }
    }
    n = n + k
}
