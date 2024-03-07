import "./big" for BigRat
import "./fmt" for Fmt

var LIMIT = 100
var bigE = BigRat.fromDecimal("2.71828182845904523536028747135266249775724709369995")

// v(n) sequence task
var c1 = BigRat.new(111)
var c2 = BigRat.new(1130)
var c3 = BigRat.new(3000)
var v1 = BigRat.two
var v2 = BigRat.new(-4)
for (i in 3..LIMIT) {
    var v3 = c1 - c2/v2 + c3/(v2*v1)
    Fmt.print("$3d : $19s", i, v3.toDecimal(16, true, true))
    v1 = v2
    v2 = v3
}

// Chaotic Building Society task
var balance = bigE - 1
for (year in 1..25) balance = balance * year - 1
System.print("\nBalance after 25 years is %(balance.toDecimal(16))")

// Siegfried Rump task
var a  = BigRat.new(77617)
var b  = BigRat.new(33096)
var c4 = BigRat.new(33375, 100)
var c5 = BigRat.new(11)
var c6 = BigRat.new(121)
var c7 = BigRat.new(11, 2)
var f = c4 * b.pow(6) + c7 * b.pow(8) + a/(b*2)
var c8 = c5 * a.pow(2) * b.pow(2) - b.pow(6) - c6 * b.pow(4) - 2
f = f + c8 * a.pow(2)
System.print("\nf(77617.0, 33096.0) is %(f.toDecimal(16))")
