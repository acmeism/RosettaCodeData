import "./gmp" for Mpz
import "./fmt" for Fmt

System.print("  N     M    Prime")
System.print("------------------")
for (n in 1..400) {
    var m = 0
    while (true) {
        var p = Mpz.from(n).mul(Mpz.one.lsh(m)).add(1)
        if (p.probPrime(15) > 0) {
            Fmt.print("$3d  $4d    $20a", n, m, p)
            break
        }
        m = m + 1
    }
}
