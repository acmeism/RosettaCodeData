import "./big" for BigInt
import "./fmt" for Conv, Fmt
import "./sort" for Sort
import "./iterate" for Indexed

var zero = BigInt.zero
var one  = BigInt.one
var two  = BigInt.two

var ew = Fn.new { |n|
    var primes = []
    var k = 1
    var P = one
    while (k < n) {
        if ((P % k) != 0) primes.add(k)
        P = P * k * k
        k = k + 1
    }
    var divs = []
    var np = primes.count
    if (np > 0) {
        for (a in 0...n) {
            var A = BigInt.new(a)
            var s = primes.map { |p| Conv.btoi(A % p == 0).toString }.join()[-1..0]
            divs.add(BigInt.new(Conv.atoi(s, 2)))
        }
    }
    var partitions = [ [zero, zero, two.pow(np) - one] ]
    var key = Fn.new { |x| (divs[x] | divs[n-x]).toBaseString(2)[-1..0].indexOf("1") }
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
            for (se in Indexed.new((factors & rPrimes).toBaseString(2)[-1..0])) {
                var ix = se.index
                var v = se.value
                if (v == "1") {
                    var w = one << ix
                    newPartitions.add([setA ^ w, setB, rPrimes ^ w])
                }
            }
            for (se in Indexed.new((otherFactors & rPrimes).toBaseString(2)[-1..0])) {
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
        var px = p[0]
        var py = p[1]
        var x = one
        var y = one
        for (p in primes) {
            if ((px % two) == one) x = x * p
            if ((py % two) == one) y = y * p
            px = px / two
            py = py / two
        }
        var N = BigInt.new(n)
        var temp = x.modInv(y) * N % y * x - N
        result = result ? BigInt.min(result, temp) : temp
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
