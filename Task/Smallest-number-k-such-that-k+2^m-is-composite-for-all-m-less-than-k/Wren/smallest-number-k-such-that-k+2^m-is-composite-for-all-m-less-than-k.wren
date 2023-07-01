import "./gmp" for Mpz

// returns true if k is a sequence member, false otherwise
var a = Fn.new { |k|
    if (k == 1) return false
    for (m in 1...k) {
        var n = Mpz.one.lsh(m).add(k)
        if (n.probPrime(15) > 0) return false
    }
    return true
}

var count = 0
var k = 1
while (count < 5) {
    if (a.call(k)) {
        System.write("%(k) ")
        count = count + 1
    }
    k = k + 2
}
System.print()
