import "./gmp" for Mpq
import "./fmt" for Fmt

var w = Mpq.new()
var h = Mpq.new()
var primes = []
var l = [500, 1000, 2500, 5000, 10000]
System.print("Wolstenholme numbers:")
for (k in 1..10000) {
    h.set(1, k * k)
    w.add(h)
    var n = w.num
    if (primes.count < 15 && n.probPrime(15) > 0) primes.add(n)
    if (k <= 20) {
        Fmt.print("$8r: $i", k, n)
    } else if (l.contains(k)) {
        var ns = n.toString
        Fmt.print("$,8r: $20a (digits: $d)", k, ns, ns.count)
    }
}
System.print("\nPrime Wolstenholme numbers:")
for (i in 0...primes.count) {
    if (i < 4) {
        Fmt.print("$8r: $i", i+1, primes[i])
    } else {
        var ps = primes[i].toString
        Fmt.print("$8r: $20a (digits: $d)", i+1, ps, ps.count)
    }
}
