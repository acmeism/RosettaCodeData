import "random" for Random
import "./fmt" for Fmt

var swap = Fn.new { |a, i, j|
    var t = a[i]
    a[i] = a[j]
    a[j] = t
}

var mrUnrank1 // recursive
mrUnrank1 = Fn.new { |rank, n, vec|
    if (n < 1) return
    var q = (rank/n).floor
    var r = rank % n
    swap.call(vec, r, n - 1)
    mrUnrank1.call(q, n - 1, vec)
}

var mrRank1 // recursive
mrRank1 = Fn.new { |n, vec, inv|
    if (n < 2) return 0
    var s = vec[n-1]
    swap.call(vec, n - 1, inv[n-1])
    swap.call(inv, s, n - 1)
    return s + n * mrRank1.call(n - 1, vec, inv)
}

var getPermutation = Fn.new { |rank, n, vec|
    for (i in 0...n) vec[i] = i
    mrUnrank1.call(rank, n, vec)
}

var getRank = Fn.new { |n, vec|
    var v   = List.filled(n, 0)
    var inv = List.filled(n, 0)
    for (i in 0...n) {
        v[i] = vec[i]
        inv[vec[i]] = i
    }
    return mrRank1.call(n, v, inv)
}

var tv = List.filled(3, 0)
for (r in 0..5) {
    getPermutation.call(r, 3, tv)
    Fmt.print("$2d -> $n -> $d", r, tv, getRank.call(3, tv))
}
System.print()
tv = List.filled(4, 0)
for (r in 0..23) {
    getPermutation.call(r, 4, tv)
    Fmt.print("$2d -> $n -> $d", r, tv, getRank.call(4, tv))
}
System.print()
tv = List.filled(12, 0)
var a = List.filled(4, 0)
var rand = Random.new()
var fact12 = (2..12).reduce(1) { |acc, i| acc * i }
for (i in 0..3) a[i] = rand.int(fact12)
for (r in a) {
    getPermutation.call(r, 12, tv)
    Fmt.print("$9d -> $n -> $d", r, tv, getRank.call(12, tv))
}
