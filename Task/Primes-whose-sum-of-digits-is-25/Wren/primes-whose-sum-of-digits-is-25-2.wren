import "./gmp" for Mpz
import "./fmt" for Fmt

var z = Mpz.new()

var countAll // recursive
countAll = Fn.new { |p, rem, res|
    if (rem == 0) {
        var b = p[-1]
        if ("1379".contains(b)) {
            if (z.setStr(p).probPrime(15) > 0) res = res + 1
        }
    } else {
        for (i in 1..rem.min(9)) {
            res = countAll.call(p + i.toString, rem - i, res)
        }
    }
    return res
}

var n = countAll.call("", 25, 0)
Fmt.print("There are $,d primes whose digits sum to 25 and include no zeros.", n)
