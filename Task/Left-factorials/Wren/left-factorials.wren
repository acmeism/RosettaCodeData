import "/fmt" for Fmt
import "/big" for BigInt

var lfacts = List.filled(12, BigInt.zero)
var lfact = BigInt.one
var sum = BigInt.zero

for (i in 1..10) {
    sum = sum + lfact
    lfacts[i] = sum
    lfact = lfact * i
}
System.print("Left factorials from 0 to 10:")
for (i in 0..10) System.write(" %(lfacts[i])")

for (i in 11..110) {
    sum = sum + lfact
    if (i%10 == 0) lfacts[i/10] = sum
    lfact = lfact * i
}
System.print("\n\nLeft factorials from 20 to 110 by tens:")
for (i in 2..11) Fmt.print(" !$-3d -> $s", i * 10, lfacts[i])

for (i in 111..10000) {
    sum = sum + lfact
    if (i%1000 == 0) lfacts[i/1000] = sum
    lfact = lfact * i
}
System.print("\nLengths of left factorals from 1000 to 10000 by thousands:")
for (i in 1..10) Fmt.print(" !$-5d -> $5s", i * 1000, lfacts[i].toString.count)
