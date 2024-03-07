import "./big" for BigInt
import "./math" for Int
import "./fmt" for Fmt

var vecprod = Fn.new { |primes|
    var le = primes.count
    if (le == 0) return BigInt.one
    var s = List.filled(le, null)
    for (i in 0...le) s[i] = BigInt.new(primes[i])
    while (le > 1) {
        var c = (le/2).floor
        for(i in 0...c) s[i] = s[i] * s[le-i-1]
        if (le & 1 ==  1) c = c + 1
        le  = c
    }
    return s[0]
}

var primes = Int.primeSieve(1.3e6) // enough to generate first 100,000 primes
var prod = 1
System.print("The first ten primorial numbers are:")
for (i in 0..9) {
    System.print("%(i):  %(prod)")
    prod = prod * primes[i]
}

System.print("\nThe following primorials have the lengths shown:")
// first multiply the first 100,000 primes together in pairs to reduce BigInt conversions needed
var primes2 = List.filled(50000, 0)
for (i in 0...50000) primes2[i] = primes[2*i] * primes[2*i+1]
for (i in [10, 100, 1000, 10000, 100000]) {
    Fmt.print("$6d:  $d", i, vecprod.call(primes2[0...i/2]).toString.count)
}
