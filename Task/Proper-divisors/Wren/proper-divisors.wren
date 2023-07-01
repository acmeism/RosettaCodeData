import "/fmt" for Fmt
import "/math" for Int

for (i in 1..10) System.print("%(Fmt.d(2, i)) -> %(Int.properDivisors(i))")

System.print("\nThe number in the range [1, 20000] with the most proper divisors is:")
var number = 1
var maxDivs = 0
for (i in 2..20000) {
    var divs = Int.properDivisors(i).count
    if (divs > maxDivs) {
        number = i
        maxDivs = divs
    }
}
System.print("%(number) which has %(maxDivs) proper divisors.")
