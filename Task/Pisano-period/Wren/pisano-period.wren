import "./math" for Int
import "./fmt" for Fmt

// Calculates the Pisano period of 'm' from first principles.
var pisanoPeriod = Fn.new { |m|
    var p = 0
    var c = 1
    for (i in 0...m*m) {
        var t = p
        p = c
        c = (t + c) % m
        if (p == 0 && c == 1) return i + 1
    }
    return 1
}

// Calculates the Pisano period of p^k where 'p' is prime and 'k' is a positive integer.
var pisanoPrime = Fn.new { |p, k|
    if (!Int.isPrime(p) || k == 0) return 0 // can't do this one
    return p.pow(k-1) * pisanoPeriod.call(p)
}

// Calculates the Pisano period of 'm' using pisanoPrime.
var pisano = Fn.new { |m|
    var primes = Int.primeFactors(m)
    var primePowers = {}
    for (p in primes) {
        var v = primePowers[p]
        primePowers[p] = v ? v + 1 : 1
    }
    var pps = []
    for (me in primePowers) pps.add(pisanoPrime.call(me.key, me.value))
    if (pps.count == 0) return 1
    if (pps.count == 1) return pps[0]
    var f = pps[0]
    var i = 1
    while (i < pps.count) {
        f = Int.lcm(f, pps[i])
        i =  i + 1
    }
    return f
}

for (p in 2..14) {
    var pp = pisanoPrime.call(p, 2)
    if (pp > 0) Fmt.print("pisanoPrime($2d: 2) = $d", p, pp)
}
System.print()
for (p in 2..179) {
    var pp = pisanoPrime.call(p, 1)
    if (pp > 0) Fmt.print("pisanoPrime($3d: 1) = $d", p, pp)
}
System.print("\npisano(n) for integers 'n' from 1 to 180 are:")
for (n in 1..180) {
    Fmt.write("$3d ", pisano.call(n))
    if (n != 1 && n%15 == 0) System.print()
}
System.print()
