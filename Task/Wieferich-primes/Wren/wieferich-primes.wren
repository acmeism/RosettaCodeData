import "/math" for Int
import "/big" for BigInt

var primes = Int.primeSieve(5000)
System.print("Wieferich primes < 5000:")
for (p in primes) {
    var num = (BigInt.one << (p - 1)) - 1
    var den = p * p
    if (num % den == 0) System.print(p)
}
