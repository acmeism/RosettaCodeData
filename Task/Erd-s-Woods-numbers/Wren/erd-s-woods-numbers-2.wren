import "./gmp" for Mpz
import "./fmt" for Conv, Fmt
import "./sort" for Sort
import "./iterate" for Indexed

var zero = Mpz.zero
var one  = Mpz.one
var two  = Mpz.two

var ew = Fn.new { |n|
    var primes = []
    var k = 1
    var P = Mpz.one
    while (k < n) {
        if (!P.isDivisibleUi(k)) primes.add(k)
        P.mul(k * k)
        k = k + 1
    }
    var divs = []
    var np = primes.count
    if (np > 0) {
        for (a in 0...n) {
            var A = Mpz.from(a)
            var s = primes.map { |p| Conv.btoi(A % p == 0).toString }.join()[-1..0]
            divs.add(Mpz.from(Conv.atoi(s, 2)))
        }
    }
    var partitions = [ [Mpz.zero, Mpz.zero, Mpz.two.pow(np) - one] ]
    var key = Fn.new { |x| (divs[x] | divs[n-x]).toString(2)[-1..0].indexOf("1") }
    var cmp = Fn.new { |i, j| (key.call(j) - key.call(i)).sign }
    for (i in Sort.merge((1...n).toList, cmp)) {
        var newPartitions = []
        var factors = divs[i]
        var otherFactors = divs[n-i]
        for (p in partitions) {
            var setA = p[0]
            var setB = p[1]
            var rPrimes = p[2]
            if ((factors & setA) != zero || (otherFactors & setB) != zero) {
                newPartitions.add(p)
                continue
            }
            for (se in Indexed.new((factors & rPrimes).toString(2)[-1..0])) {
                var ix = se.index
                var v = se.value
                if (v == "1") {
                    var w = one << ix
                    newPartitions.add([setA ^ w, setB, rPrimes ^ w])
                }
            }
            for (se in Indexed.new((otherFactors & rPrimes).toString(2)[-1..0])) {
                var ix = se.index
                var v = se.value
                if (v == "1") {
                    var w = one << ix
                    newPartitions.add([setA, setB ^ w, rPrimes ^ w])
                }
            }
        }
        partitions = newPartitions
    }
    var result = null
    for (p in partitions) {
        var px = p[0].copy()
        var py = p[1].copy()
        var x = Mpz.one
        var y = Mpz.one
        for (p in primes) {
            if (px.isOdd) x.mul(p)
            if (py.isOdd) y.mul(p)
            px.div(2)
            py.div(2)
        }
        var N = Mpz.from(n)
        var x2 = x.copy()
        var temp = x.modInv(y).mul(N).rem(y).mul(x2).sub(N)
        result = result ? Mpz.min(result, temp) : temp
    }
    return result
}

var k = 3
var count = 0
System.print("The first 20 Erdős–Woods numbers and their minimum interval start values are:")
while (count < 20) {
    var a = ew.call(k)
    if (a) {
        Fmt.print("$3d -> $i", k, a)
        count = count + 1
    }
    k = k + 1
}
