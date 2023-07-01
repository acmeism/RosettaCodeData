import "/big" for BigInt
import "/fmt" for Fmt

var branches = 4
var nMax = 250
var rooted = List.filled(nMax + 1, BigInt.zero)
var unrooted = List.filled(nMax + 1, BigInt.zero)
var c = List.filled(branches, BigInt.zero)

var tree
tree = Fn.new { |br, n, l, sum, cnt|
    var b = br + 1
    while (b <= branches) {
        sum = sum + n
        if (sum > nMax) return
        if (l*2 >= sum && b >= branches) return
        if (b == br + 1) {
            c[br] = rooted[n] * cnt
        } else {
            var tmp = rooted[n] + BigInt.new(b - br - 1)
            c[br] = c[br] * tmp
            c[br] = c[br] / BigInt.new(b - br)
        }
        if (l*2 < sum) unrooted[sum] = unrooted[sum] + c[br]
        if (b < branches) rooted[sum] = rooted[sum] + c[br]
        var m = n - 1
        while (m > 0) {
            tree.call(b, m, l, sum, c[br])
            m = m - 1
        }
        b = b + 1
    }
}

var bicenter = Fn.new { |s|
    if (s%2 == 0) {
        var tmp = (rooted[(s/2).floor] + BigInt.one) * rooted[(s/2).floor]
        tmp = tmp >> 1
        unrooted[s] = unrooted[s] + tmp
    }
}

rooted[0] = BigInt.one
rooted[1] = BigInt.one
unrooted[0] = BigInt.one
unrooted[1] = BigInt.one
for (n in 1..nMax) {
    tree.call(0, n, n, 1, BigInt.one)
    bicenter.call(n)
    Fmt.print("$3d: $i", n, unrooted[n])
}
