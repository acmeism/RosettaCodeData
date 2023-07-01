import "./gmp" for Mpz
import "./fmt" for Fmt

var sumMultiples = Fn.new { |result, limit, f|
    var m = Mpz.from(limit).sub(1).fdiv(f)
    result.set(m).inc.mul(m).mul(f).rsh(1)
}

var limit = Mpz.one
var tempSum = Mpz.new()
var sum35 = Mpz.new()
var max = 25
Fmt.print("$*s  $s", max + 1, "limit", "sum")
for (i in 0..max) {
    Fmt.write("$*s  ", max + 1, limit)
    sumMultiples.call(tempSum, limit, 3)
    sum35.set(tempSum)
    sumMultiples.call(tempSum, limit, 5)
    sum35.add(tempSum)
    sumMultiples.call(tempSum, limit, 15)
    sum35.sub(tempSum)
    System.print(sum35)
    limit.mul(10)
}
