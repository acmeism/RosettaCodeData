import "./math" for Int
import "./fmt" for Conv, Fmt

System.print("Primes < 500 which are palindromic in base 16:")
var primes = Int.primeSieve(500)
var count = 0
for (p in primes) {
    var hp = Conv.Itoa(p, 16)
    if (hp == hp[-1..0]) {
        Fmt.write("$3s ", hp)
        count = count + 1
        if (count % 5 == 0) System.print()
    }
}
System.print("\n\nFound %(count) such primes.")
