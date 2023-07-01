import "/math" for Int
import "/big" for BigInt
import "/fmt" for Fmt

var MAX = 33
var primes = Int.primeSieve(MAX * 5)
System.print("The first %(MAX) terms in the sequence are:")
for (i in 1..MAX) {
    if (Int.isPrime(i)) {
        var z = BigInt.new(primes[i-1]).pow(i-1)
        Fmt.print("$2d : $i", i, z)
    } else {
        var count = 0
        var j = 1
        while (true) {
            var cont = false
            if (i % 2 == 1) {
                var sq = j.sqrt.floor
                if (sq * sq != j) {
                    j = j + 1
                    cont = true
                }
            }
            if (!cont) {
                if (Int.divisors(j).count == i) {
                    count = count + 1
                    if (count == i) {
                        Fmt.print("$2d : $d", i, j)
                        break
                    }
                }
                j = j + 1
            }
        }
    }
}
