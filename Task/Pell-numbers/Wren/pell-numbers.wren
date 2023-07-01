import "./big" for BigInt, BigRat
import "./math" for Int
import "./fmt" for Fmt

var p = List.filled(40, 0)
p[0] = 0
p[1] = 1
for (i in 2..39) p[i] = 2 * p[i-1] + p[i-2]
System.print("The first 20 Pell numbers are:")
System.print(p[0..19].join(" "))

var q = List.filled(40, 0)
q[0] = 2
q[1] = 2
for (i in 2..39) q[i] = 2 * q[i-1] + q[i-2]
System.print("\nThe first 20 Pell-Lucas numbers are:")
System.print(q[0..19].join(" "))

System.print("\nThe first 20 rational approximations of √2 (1.4142135623730951) are:")
for (i in 1..20) {
    var r = BigRat.new(q[i]/2, p[i])
    Fmt.print("$-17s ≈ $-18s", r, r.toDecimal(16, true, true))
}

System.print("\nThe first 15 Pell primes are:")
var p0 = BigInt.zero
var p1 = BigInt.one
var indices = List.filled(15, 0)
var count = 0
var index = 2
var p2
while (count < 15) {
    p2 = p1 * BigInt.two + p0
    if (Int.isPrime(index) && p2.isProbablePrime(10)) {
        System.print(p2)
        indices[count] = index
        count = count + 1
    }
    index = index + 1
    p0 = p1
    p1 = p2
}

System.print("\nIndices of the first 15 Pell primes are:")
System.print(indices.join(" "))

System.print("\nFirst 20 Newman-Shank_Williams numbers:")
var nsw = List.filled(20, 0)
for (n in 0..19) nsw[n] = p[2*n] + p[2*n+1]
Fmt.print("$d", nsw)

System.print("\nFirst 20 near isosceles right triangles:")
p0 = 0
p1 = 1
var sum = 1
var i = 2
while (i < 43) {
    p2 = p1 * 2 + p0
    if (i % 2 == 1) {
        Fmt.print("($d, $d, $d)", sum, sum + 1, p2)
    }
    sum = sum + p2
    p0 = p1
    p1 = p2
    i = i + 1
}
