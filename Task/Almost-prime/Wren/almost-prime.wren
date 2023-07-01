var kPrime = Fn.new { |n, k|
    var nf = 0
    var i = 2
    while (i <= n) {
        while (n%i == 0) {
            if (nf == k) return false
            nf = nf + 1
            n = (n/i).floor
        }
        i = i + 1
    }
    return nf == k
}

var gen = Fn.new { |k, n|
    var r = List.filled(n, 0)
    n = 2
    for (i in 0...r.count) {
        while (!kPrime.call(n, k)) n = n + 1
        r[i] = n
        n = n + 1
    }
    return r
}

for (k in 1..5) System.print("%(k) %(gen.call(k, 10))")
