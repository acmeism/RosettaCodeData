import "/fmt" for Fmt
import "/math" for Int

var max = 120
System.print("The attractive numbers up to and including %(max) are:")
var count = 0
for (i in 1..max) {
    var n = Int.primeFactors(i).count
    if (Int.isPrime(n)) {
        System.write(Fmt.d(4, i))
        count = count + 1
        if (count%20 == 0) System.print()
    }
}
System.print()
