import "./math" for Int

var pi = Fn.new { |n|
    if (n < 3) return (n < 2) ? 0 : 1
    var primes = Int.primeSieve(n.sqrt.floor)
    var a = primes.count

    var phi // recursive closure
    phi = Fn.new { |x, a|
        if (a <= 1) return (a < 1) ? x : x - (x >> 1)
        var pa = primes[a-1]
        if (x <= pa) return 1
        return phi.call(x, a-1) - phi.call((x/pa).floor, a-1)
    }

    return phi.call(n, a) + a - 1
}

var n = 1
for (i in 0..9) {
    System.print("10^%(i)  %(pi.call(n))")
    n = n * 10
}
