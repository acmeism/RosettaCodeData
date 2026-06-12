import "./gmp" for Mpz
import "./fmt" for Fmt

var fib = Mpz.new()
var p = Mpz.new()
var prev = Mpz.zero
var curr = Mpz.one
var count = 0
System.print("First 30 Iccanobif primes:")
while (count < 30) {
    fib.add(curr, prev)
    var fs = fib.toString
    p.setStr(fs[-1..0])
    if (p.probPrime(15) > 0) {
        count =  count + 1
        var pc = p.toString.count
        Fmt.print("$2d: $20a ($d digits)", count, p, pc)
    }
    prev.set(curr)
    curr.set(fib)
}
