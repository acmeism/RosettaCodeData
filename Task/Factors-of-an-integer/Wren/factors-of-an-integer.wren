import "/fmt" for Fmt
import "/math" for Int

var a = [11, 21, 32, 45, 67, 96, 159, 723, 1024, 5673, 12345, 32767, 123459, 999997]
System.print("The factors of the following numbers are:")
for (e in a) System.print("%(Fmt.d(6, e)) => %(Int.divisors(e))")
