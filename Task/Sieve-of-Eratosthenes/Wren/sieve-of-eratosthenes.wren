var sieveOfE = Fn.new { |n|
    if (n < 2) return []
    var comp = List.filled(n-1, false)
    var p = 2
    while (true) {
        var p2 = p * p
        if (p2 > n) break
        var i = p2
        while (i <= n) {
            comp[i-2] = true
            i = i + p
        }
        while (true) {
            p = p + 1
            if (!comp[p-2]) break
        }
    }
    var primes = []
    for (i in 0..n-2) {
        if (!comp[i]) primes.add(i+2)
    }
    return primes
}

System.print(sieveOfE.call(100))
