import "./gmp" for Mpz, Mpq
import "./fmt" for Fmt

var q = Mpq.new()
var p = Mpz.new()
var r = Mpq.new()
var s = Mpq.new()
var count = 0
var limit = 16
Fmt.print("First $d elements of the sequence:", limit)
while (count < limit) {
     q.set(Mpq.one.sub(s)).inv
     var isInteger = (q.den == Mpz.one)
     if (isInteger) p.set(q.toMpz) else p.set(q.toMpz.inc)
     p.nextPrime(p)
     count = count + 1
     var ps = p.toString
     Fmt.write("$2d: $20a", count, p)
     if (ps.count > 40) {
        Fmt.print(" (digits: $d)", ps.count)
     } else {
        System.print()
     }
     r.set(p).inv
     s.add(r)
}
