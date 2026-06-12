import "./fmt" for Fmt
import "./big" for BigRat

var t = List.filled(30, 0)
for (n in 1..29) t[n] = t[n-1] + n
System.print("The first 30 triangular numbers are:")
Fmt.tprint("$3d", t, 6)

for (n in 1..29) t[n] = t[n] + t[n-1]
System.print("\nThe first 30 tetrahedral numbers are:")
Fmt.tprint("$4d", t, 6)

for (n in 1..29) t[n] = t[n] + t[n-1]
System.print("\nThe first 30 pentatopic numbers are:")
Fmt.tprint("$5d", t, 6)

for (r in 5..12) {
    for (n in 1..29) t[n] = t[n] + t[n-1]
}
System.print("\nThe first 30 12-simplex numbers are:")
Fmt.tprint("$10d", t, 6)

var xs = [7140, 21408696, 26728085384, 14545501785001]
var digs = 16
for (x in xs) {
    var bx = BigRat.new(x)
    System.print("\nRoots of %(x):")
    var root = ((bx*8 + 1).sqrt(digs) - 1)/2
    Fmt.print("$14s: $s", "triangular", root.toDecimal(digs-5))

    var temp = (bx*bx*9 - BigRat.new(1, 27)).sqrt(digs)
    root = (bx*3 + temp).cbrt(digs) + (bx*3 - temp).cbrt(digs) - 1
    Fmt.print("$14s: $s", "tetrahedral", root.toDecimal(digs-5))

    root = (((bx*24 + 1).sqrt(digs)*4 + 5).sqrt(digs) - 3) / 2
    Fmt.print("$14s: $s", "pentatopic", root.toDecimal(digs-5))
}
